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
    
    @Inject private var module: ShowBlogModuleType
    
    private lazy var action: ShowBlogActionable = module.component(with: self)
    private(set) lazy var router: ShowBlogRoutable = module.component(with: self)
    
    private lazy var mailComposer: MailComposerType = module.component()
    private lazy var constants: ConstantsType = module.component()
    private lazy var theme: Theme = module.component()
    
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
        action.fetchLatestPosts(
            with: ShowBlogAPI.FetchPostsRequest(maxLength: 30)
        )
        
        action.fetchPopularPosts(
            with: ShowBlogAPI.FetchPostsRequest(maxLength: 30)
        )
        
        action.fetchTopPickPosts(
            with: ShowBlogAPI.FetchPostsRequest(maxLength: 30)
        )
        
        action.fetchTerms(
            with: ShowBlogAPI.FetchTermsRequest(maxLength: 6)
        )
    }
}

// MARK: - Interactions

private extension ShowBlogViewController {
    
    @IBAction func popularPostsSeeAllButtonTapped() {
        router.listPosts(params: .init(fetchType: .popular))
    }
    
    @IBAction func topPickedPostsSeeAllButtonTapped() {
        router.listPosts(params: .init(fetchType: .picks))
    }
    
    @IBAction func topTermsSeeAllButtonTapped(_ sender: Any) {
        router.listTerms()
    }
    
    @IBAction func disclaimerButtonTapped() {
        guard let disclaimerURL = constants.disclaimerURL else {
            present(
                alert: .localized(.disclaimerNotAvailableErrorTitle),
                message: .localized(.disclaimerNotAvailableErrorMessage)
            )
            
            return
        }
        
        present(safari: disclaimerURL, theme: theme)
    }
    
    @IBAction func privacyButtonTapped() {
        present(safari: constants.privacyURL, theme: theme)
    }
    
    @IBAction func contactButtonTapped() {
        guard let controller = mailComposer.makeViewController(email: constants.email) else {
            present(
                alert: .localized(.couldNotSendEmail),
                message: .localized(.couldNotSendEmailMessage)
            )
            
            return
        }
        
        present(controller)
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
        // Nothing to do
    }
    
    func endRefreshing() {
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - Delegates

extension ShowBlogViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router.showPost(for: model)
    }
    
    func postsDataView(toggleFavorite model: PostsDataViewModel) {
        action.toggleFavorite(
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
        router.listPosts(
            params: .init(
                fetchType: .terms([model.id]),
                title: model.name
            )
        )
    }
}

@available(iOS 13.0, *)
extension ShowBlogViewController {
    
    func postsDataView(contextMenuConfigurationFor model: PostsDataViewModel, at indexPath: IndexPath, point: CGPoint, from dataView: DataViewable) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(for: model, at: indexPath, from: dataView, delegate: self, constants: constants, theme: theme)
    }
    
    func postsDataView(didPerformPreviewActionFor model: PostsDataViewModel, from dataView: DataViewable) {
        router.showPost(for: model.id)
    }
}

extension ShowBlogViewController: TabSelectable {
    
    func tabDidSelect() {
        guard isViewLoaded else { return }
        scrollView?.scrollToTop()
    }
}
