//
//  ExploreViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Combine
import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

final class ShowBlogViewController: UIViewController {
    private let model: ShowBlogModel
    private let interactor: ShowBlogInteractable?
    private let constants: Constants
    private let theme: Theme
    
    private(set) var render: ShowBlogRenderable?
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Controls
    
    private lazy var scrollStackView = makeScrollStackView(refreshAction: #selector(fetch))
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
        model: ShowBlogModel,
        interactor: ShowBlogInteractable?,
        render: ((UIViewController) -> ShowBlogRenderable)?,
        constants: Constants,
        theme: Theme
    ) {
        self.model = model
        self.interactor = interactor
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
        observe()
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingRemoved else { return }
        cancellable.removeAll()
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
    }
    
    func observe() {
        model.$latestPosts
            .compactMap { $0 }
            .sink(receiveValue: latestPostsCollectionViewAdapter.reloadData)
            .store(in: &cancellable)
        
        model.$popularPosts
            .compactMap { $0 }
            .sink(receiveValue: popularPostsCollectionViewAdapter.reloadData)
            .store(in: &cancellable)
        
        model.$topPickPosts
            .compactMap { $0 }
            .sink(receiveValue: pickedPostsCollectionViewAdapter.reloadData)
            .store(in: &cancellable)
        
        model.$terms
            .compactMap { $0 }
            .sink(receiveValue: topTermsTableViewAdapter.reloadData)
            .store(in: &cancellable)
        
        model.$error
            .sink(receiveValue: load)
            .store(in: &cancellable)
        
        #warning("Publisher needs to end refreshing accurately")
        Publishers
            .Zip4(
                model.$latestPosts.eraseToAnyPublisher(),
                model.$popularPosts.eraseToAnyPublisher(),
                model.$topPickPosts.eraseToAnyPublisher(),
                model.$terms.eraseToAnyPublisher()
            )
            .sink { [weak self] _ in
                self?.endRefreshing()
            }
            .store(in: &cancellable)
    }
    
    @objc func fetch() {
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
}

private extension ShowBlogViewController {
    
    func load(error: ViewError?) {
        guard let error = error else { return }
        endRefreshing()
        present(alert: error.title, message: error.message)
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

// MARK: - Helpers

extension ShowBlogViewController {
    
    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            
            if self?.scrollStackView.refreshControl?.isRefreshing == true {
                self?.scrollStackView.refreshControl?.endRefreshing()
            }
        }
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
                model: .preview,
                interactor: nil,
                render: nil,
                constants: AppPreviews.shared.core.constants(),
                theme: AppPreviews.shared.core.theme()
            )
        ).previews
    }
}
#endif
