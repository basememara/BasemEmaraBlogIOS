//
//  ExploreViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

final class ShowBlogViewController: UIViewController {
    private let store: Store<ShowBlogState>
    private let interactor: ShowBlogInteractable?
    private let constants: Constants
    private let theme: Theme
    private var cancellable: NotificationCenter.Cancellable?
    
    var render: ShowBlogRenderable?
    
    // MARK: - Controls
    
    private lazy var scrollStackView = makeScrollStackView()
    private lazy var activityIndicatorView = view.makeActivityIndicator()
    
    private lazy var latestPostsCollectionView = makeLatestPostsCollectionView()
    private lazy var latestPostsCollectionViewAdapter = PostsDataViewAdapter(
        for: latestPostsCollectionView,
        delegate: self
    )
    
    private lazy var popularPostsCollectionView = makePopularPostsCollectionView()
    private lazy var popularPostsCollectionViewAdapter = PostsDataViewAdapter(
        for: popularPostsCollectionView,
        delegate: self
    )
    
    private lazy var pickedPostsCollectionView = makePickedPostsCollectionView()
    private lazy var pickedPostsCollectionViewAdapter = PostsDataViewAdapter(
        for: pickedPostsCollectionView,
        delegate: self
    )
    
    private lazy var topTermsTableView = makeTopTermsTableView()
    private lazy var topTermsTableViewAdapter = TermsDataViewAdapter(
        for: topTermsTableView,
        delegate: self
    )
    
    // MARK: - Initializers
    
    init(
        store: Store<ShowBlogState>,
        interactor: ShowBlogInteractable?,
        constants: Constants,
        theme: Theme
    ) {
        self.store = store
        self.interactor = interactor
        self.constants = constants
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        fetch()
    }
    
    override func loadView() {
        view = scrollStackView
    }
}

// MARK: - Setup

private extension ShowBlogViewController {
    
    func prepare() {
        // Configure controls
        navigationItem.titleView = makeTitle()
        navigationController?.navigationBar.prefersLargeTitles = false
        activityIndicatorView.startAnimating()
        
        // Compose layout
        scrollStackView.add(rows: [
            latestPostsCollectionView,
            makeHeader(
                title: .localized(.popularPostsTitle),
                buttonTitle: .localized(.seeAllButton),
                buttonAction: #selector(didTapPopularPostsSeeAllButton)
            ),
            popularPostsCollectionView,
            makeHeader(
                title: .localized(.postsByTermsTitle),
                buttonTitle: .localized(.seeAllButton),
                buttonAction: #selector(didTapTermsSeeAllButton)
            ),
            topTermsTableView,
            makeHeader(
                title: .localized(.topPicksTitle),
                buttonTitle: .localized(.seeAllButton),
                buttonAction: #selector(didTapTopPickedPostsSeeAllButton)
            ),
            pickedPostsCollectionView,
            makeFooter()
        ])
        
        // Bind state
        store(in: &cancellable, observer: load)
    }
    
    func fetch() {
        interactor?.fetchLatestPosts(
            with: ShowBlogAPI.FetchPostsRequest(maxLength: 30)
        )
        
        interactor?.fetchPopularPosts(
            with: ShowBlogAPI.FetchPostsRequest(maxLength: 30)
        )
        
        interactor?.fetchTopPickPosts(
            with: ShowBlogAPI.FetchPostsRequest(maxLength: 30)
        )
        
        interactor?.fetchTerms(
            with: ShowBlogAPI.FetchTermsRequest(maxLength: 6)
        )
    }
    
    func load(_ state: ShowBlogState) {
        latestPostsCollectionViewAdapter.reloadData(
            with: state.latestPosts
        )
        
        popularPostsCollectionViewAdapter.reloadData(
            with: state.popularPosts
        )
        
        pickedPostsCollectionViewAdapter.reloadData(
            with: state.topPickPosts
        )
        
        topTermsTableViewAdapter.reloadData(
            with: state.terms
        )
        
        // TODO: Handle error
        
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - Interactions

extension ShowBlogViewController {
    
    @objc func didTapPopularPostsSeeAllButton() {
        render?.listPosts(
            params: ListPostsAPI.Params(fetchType: .popular)
        )
    }
    
    @objc func didTapTopPickedPostsSeeAllButton() {
        render?.listPosts(
            params: ListPostsAPI.Params(fetchType: .picks)
        )
    }
    
    @objc func didTapTermsSeeAllButton() {
        render?.listTerms()
    }
    
    @objc func didTapDisclaimerButton() {
        render?.showDisclaimer(url: constants.disclaimerURL)
    }
    
    @objc func didTapPrivacyButton() {
        render?.show(url: constants.privacyURL)
    }
    
    @objc func didTapContactButton() {
        render?.sendEmail(to: constants.email)
    }
}

// MARK: - Delegates

extension ShowBlogViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        render?.showPost(for: model)
    }
    
    func postsDataView(toggleFavorite model: PostsDataViewModel) {
        interactor?.toggleFavorite(
            with: ShowBlogAPI.FavoriteRequest(
                postID: model.id
            )
        )
    }
    
    func postsDataViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Snap page and center collection view cell
        let snapPagingLayout: ScrollableFlowLayout? = {
            switch scrollView {
            case latestPostsCollectionView:
                return latestPostsCollectionView.collectionViewLayout as? SnapPagingLayout
            case pickedPostsCollectionView:
                return pickedPostsCollectionView.collectionViewLayout as? SnapPagingLayout
            default:
                return nil
            }
        }()
        
        snapPagingLayout?.willBeginDragging()
    }
    
    func postsDataViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Snap page and center collection view cell
        let snapPagingLayout: ScrollableFlowLayout? = {
            switch scrollView {
            case latestPostsCollectionView:
                return latestPostsCollectionView.collectionViewLayout as? SnapPagingLayout
            case popularPostsCollectionView:
                return popularPostsCollectionView.collectionViewLayout as? MultiRowLayout
            case pickedPostsCollectionView:
                return pickedPostsCollectionView.collectionViewLayout as? SnapPagingLayout
            default:
                return nil
            }
        }()
        
        snapPagingLayout?.willEndDragging(
            withVelocity: velocity,
            targetContentOffset: targetContentOffset
        )
    }
}

extension ShowBlogViewController: TermsDataViewDelegate {
    
    func termsDataView(didSelect model: TermsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        render?.listPosts(
            params: ListPostsAPI.Params(
                fetchType: .terms([model.id]),
                title: model.name
            )
        )
    }
}

@available(iOS 13, *)
extension ShowBlogViewController {
    
    func postsDataView(contextMenuConfigurationFor model: PostsDataViewModel, at indexPath: IndexPath, point: CGPoint, from dataView: DataViewable) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(
            for: model,
            at: indexPath,
            from: dataView,
            delegate: self,
            constants: constants,
            theme: theme,
            additionalActions: {
                guard case latestPostsCollectionView = dataView as? UICollectionView else { return [] }
                
                return [
                    UIAction(
                        title: .localized(model.favorite == true ? .unfavoriteTitle : .favoriteTitle),
                        image: UIImage(systemName: model.favorite == true ? "star.fill" : "star"),
                        handler: { [weak self] _ in
                            self?.interactor?.toggleFavorite(
                                with: ShowBlogAPI.FavoriteRequest(
                                    postID: model.id
                                )
                            )
                        }
                    )
                ]
            }()
        )
    }
    
    func postsDataView(didPerformPreviewActionFor model: PostsDataViewModel, from dataView: DataViewable) {
        render?.showPost(for: model)
    }
}

extension ShowBlogViewController: MainSelectable {
    
    func mainDidSelect() {
        guard isViewLoaded else { return }
        scrollStackView.scrollToTop()
    }
}