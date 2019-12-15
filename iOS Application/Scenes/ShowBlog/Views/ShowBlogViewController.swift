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

class ShowBlogViewController: UIViewController {
    
    // MARK: - Controls
    
    @IBOutlet private weak var popularTitleLabel: UILabel!
    @IBOutlet private weak var tagTitleLabel: UILabel!
    @IBOutlet private weak var picksTitleLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var titleView: UIView! // Needs strong reference, see storyboard
    
    @IBOutlet private weak var latestPostsCollectionView: UICollectionView! {
        didSet { latestPostsCollectionView.register(cell: LatestPostCollectionViewCell.self) }
    }
    
    @IBOutlet private weak var popularPostsCollectionView: UICollectionView! {
        didSet { popularPostsCollectionView.register(cell: PopularPostCollectionViewCell.self) }
    }
    
    @IBOutlet private weak var pickedPostsCollectionView: UICollectionView! {
        didSet { pickedPostsCollectionView.register(cell: PickedPostCollectionViewCell.self) }
    }
    
    @IBOutlet private weak var topTermsTableView: UITableView! {
        didSet { topTermsTableView.register(nib: TermTableViewCell.self) }
    }
    
    // MARK: - Dependencies
    
    var core: ShowBlogCoreType?
    
    private lazy var action: ShowBlogActionable? = core?.dependency(with: self)
    private(set) lazy var router: ShowBlogRouterable? = core?.dependency(with: self)
    
    private lazy var constants: ConstantsType? = core?.dependency()
    private lazy var theme: Theme? = core?.dependency()
    
    // MARK: - State
    
    private lazy var latestPostsCollectionViewAdapter = PostsDataViewAdapter(
        for: latestPostsCollectionView,
        delegate: self
    )
    
    private lazy var popularPostsCollectionViewAdapter = PostsDataViewAdapter(
        for: popularPostsCollectionView,
        delegate: self
    )
    
    private lazy var pickedPostsCollectionViewAdapter = PostsDataViewAdapter(
        for: pickedPostsCollectionView,
        delegate: self
    )
    
    private lazy var topTermsTableViewAdapter = TermsDataViewAdapter(
        for: topTermsTableView,
        delegate: self
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
}

// MARK: - Setup

private extension ShowBlogViewController {
    
    func configure() {
        navigationItem.titleView = titleView
        
        latestPostsCollectionView.collectionViewLayout = SnapPagingLayout(
            centerPosition: true,
            peekWidth: 40,
            spacing: 20,
            inset: 16
        )
        
        popularPostsCollectionView.decelerationRate = .fast
        popularPostsCollectionView.collectionViewLayout = MultiRowLayout(
            rowsCount: 3,
            inset: 16
        )
        
        pickedPostsCollectionView.collectionViewLayout = SnapPagingLayout(
            centerPosition: false,
            peekWidth: 20,
            spacing: 10,
            inset: 16
        )
    }
    
    func loadData() {
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
}

// MARK: - Interactions

private extension ShowBlogViewController {
    
    @IBAction func popularPostsSeeAllButtonTapped() {
        router?.listPosts(
            params: ListPostsAPI.Params(fetchType: .popular)
        )
    }
    
    @IBAction func topPickedPostsSeeAllButtonTapped() {
        router?.listPosts(
            params: ListPostsAPI.Params(fetchType: .picks)
        )
    }
    
    @IBAction func topTermsSeeAllButtonTapped(_ sender: Any) {
        router?.listTerms()
    }
    
    @IBAction func disclaimerButtonTapped() {
        router?.showDisclaimer(url: constants?.disclaimerURL)
    }
    
    @IBAction func privacyButtonTapped() {
        router?.show(url: constants?.privacyURL)
    }
    
    @IBAction func contactButtonTapped() {
        router?.sendEmail(to: constants?.email)
    }
}

// MARK: - Scene

extension ShowBlogViewController: ShowBlogDisplayable {
    
    func displayLatestPosts(with viewModels: [PostsDataViewModel]) {
        latestPostsCollectionViewAdapter.reloadData(with: viewModels)
        endRefreshing()
    }
    
    func displayPopularPosts(with viewModels: [PostsDataViewModel]) {
        popularPostsCollectionViewAdapter.reloadData(with: viewModels)
    }
    
    func displayTopPickPosts(with viewModels: [PostsDataViewModel]) {
        pickedPostsCollectionViewAdapter.reloadData(with: viewModels)
    }
    
    func displayTerms(with viewModels: [TermsDataViewModel]) {
        topTermsTableViewAdapter.reloadData(with: viewModels)
    }
    
    func displayToggleFavorite(with viewModel: ShowBlogAPI.FavoriteViewModel) {
        // Refresh favorite status in collection if applicable
        // TODO: Migrate to reactive views then wouldn't need to fetch
        if latestPostsCollectionViewAdapter.viewModels?
            .contains(where: { $0.id == viewModel.postID }) == true {
                action?.fetchLatestPosts(
                    with: ShowBlogAPI.FetchPostsRequest(maxLength: 30)
                )
        }
    }
    
    func endRefreshing() {
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - Delegates

extension ShowBlogViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router?.showPost(for: model)
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
        router?.listPosts(
            params: ListPostsAPI.Params(
                fetchType: .terms([model.id]),
                title: model.name
            )
        )
    }
}

@available(iOS 13.0, *)
extension ShowBlogViewController {
    
    func postsDataView(contextMenuConfigurationFor model: PostsDataViewModel, at indexPath: IndexPath, point: CGPoint, from dataView: DataViewable) -> UIContextMenuConfiguration? {
        guard let constants = constants, let theme = theme else { return nil }
        
        return UIContextMenuConfiguration(
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
        router?.showPost(for: model)
    }
}

extension ShowBlogViewController: TabSelectable {
    
    func tabDidSelect() {
        guard isViewLoaded else { return }
        scrollView?.scrollToTop()
    }
}
