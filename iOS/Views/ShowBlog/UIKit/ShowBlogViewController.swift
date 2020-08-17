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
    private let state: ShowBlogState
    private let action: ShowBlogActionable?
    private let constants: Constants
    private let theme: Theme
    
    private(set) var render: ShowBlogRenderable?
    
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
        state: ShowBlogState,
        action: ShowBlogActionable?,
        render: ((UIViewController) -> ShowBlogRenderable)?,
        constants: Constants,
        theme: Theme
    ) {
        self.state = state
        self.action = action
        self.constants = constants
        self.theme = theme
        
        super.init(nibName: nil, bundle: nil)
        self.render = render?(self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = scrollStackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingRemoved else { return }
        state.unsubscribe()
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
        
        // Bind reactive data
        state.subscribe(load)
    }
    
    func fetch() {
        action?.fetchLatestPosts(
            with: ShowBlogAPI.FetchPostsRequest(maxLength: 30)
        )
        
        action?.fetchPopularPosts(
            with: ShowBlogAPI.FetchPostsRequest(maxLength: 30)
        )
        
        action?.fetchTopPickPosts(
            with: ShowBlogAPI.FetchPostsRequest(maxLength: 30)
        )
        
        action?.fetchTerms(
            with: ShowBlogAPI.FetchTermsRequest(maxLength: 6)
        )
    }
    
    func load(_ result: StateChange<ShowBlogState>) {
        if result == .updated(\ShowBlogState.latestPosts) || result == .initial {
            latestPostsCollectionViewAdapter.reloadData(with: state.latestPosts)
        }
        
        if result == .updated(\ShowBlogState.popularPosts) || result == .initial {
            popularPostsCollectionViewAdapter.reloadData(with: state.popularPosts)
        }
        
        if result == .updated(\ShowBlogState.topPickPosts) || result == .initial {
            pickedPostsCollectionViewAdapter.reloadData(with: state.topPickPosts)
        }
        
        if result == .updated(\ShowBlogState.terms) || result == .initial {
            topTermsTableViewAdapter.reloadData(with: state.terms)
        }
        
        if case .failure(let error) = result {
            activityIndicatorView.stopAnimating()
            present(alert: error.title, message: error.message)
        }
        
        // Stop loader when all sections populated
        if latestPostsCollectionViewAdapter.viewModels?.isEmpty == false
            && popularPostsCollectionViewAdapter.viewModels?.isEmpty == false
            && pickedPostsCollectionViewAdapter.viewModels?.isEmpty == false
            && topTermsTableViewAdapter.viewModels?.isEmpty == false {
            activityIndicatorView.stopAnimating()
        }
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
        action?.toggleFavorite(
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
                            self?.action?.toggleFavorite(
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

// MARK: - Preview

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct ShowBlogControllerPreview: PreviewProvider {
    
    static var previews: some View {
        UINavigationController(
            rootViewController: ShowBlogViewController(
                state: Preview.showBlogState,
                action: nil,
                render: nil,
                constants: Preview.core.constants(),
                theme: Preview.core.theme()
            )
        ).previews
    }
}
#endif
