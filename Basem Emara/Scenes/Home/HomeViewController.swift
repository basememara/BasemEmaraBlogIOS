//
//  ExploreViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit
import SwiftyPress
import TinyConstraints
import SafariServices

class HomeViewController: UIViewController, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet private weak var popularTitleLabel: UILabel!
    @IBOutlet private weak var tagTitleLabel: UILabel!
    @IBOutlet private weak var picksTitleLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private var titleView: UIView! // Needs strong reference, see storyboard
    
    @IBOutlet private weak var latestPostsCollectionView: UICollectionView! {
        didSet { latestPostsCollectionView.register(nib: LatestPostCollectionViewCell.self, inBundle: .swiftyPress) }
    }
    
    @IBOutlet private weak var popularPostsCollectionView: UICollectionView! {
        didSet { popularPostsCollectionView.register(nib: PopularPostCollectionViewCell.self, inBundle: .swiftyPress) }
    }
    
    @IBOutlet private weak var pickedPostsCollectionView: UICollectionView! {
        didSet { pickedPostsCollectionView.register(nib: PickedPostCollectionViewCell.self, inBundle: .swiftyPress) }
    }
    
    @IBOutlet private weak var topTermsTableView: UITableView! {
        didSet { topTermsTableView.register(nib: TermTableViewCell.self, inBundle: .swiftyPress) }
    }
    
    // MARK: - Scene variables
    
    private lazy var interactor: HomeBusinessLogic = HomeInteractor(
        presenter: HomePresenter(viewController: self),
        postWorker: dependencies.resolveWorker(),
        mediaWorker: dependencies.resolveWorker(),
        taxonomyWorker: dependencies.resolveWorker(),
        preferences: dependencies.resolve()
    )
    
    private(set) lazy var router: HomeRoutable = HomeRouter(
        viewController: self
    )
    
    // MARK: - Internal variable
    
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
    
    private lazy var mailComposer: MailComposerType = dependencies.resolve()
    private lazy var constants: ConstantsType = dependencies.resolve()
    private lazy var theme: Theme = dependencies.resolve()
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
}

// MARK: - Events

private extension HomeViewController {
    
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
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: latestPostsCollectionView)
            registerForPreviewing(with: self, sourceView: popularPostsCollectionView)
            registerForPreviewing(with: self, sourceView: pickedPostsCollectionView)
        }
    }
    
    func loadData() {
        interactor.fetchLatestPosts(
            with: HomeModels.FetchPostsRequest(count: 30)
        )
        
        interactor.fetchPopularPosts(
            with: HomeModels.FetchPostsRequest(count: 30)
        )
        
        interactor.fetchTopPickPosts(
            with: HomeModels.FetchPostsRequest(count: 30)
        )
        
        interactor.fetchTerms(
            with: HomeModels.FetchTermsRequest(count: 6)
        )
    }
}

// MARK: - Scene cycle

extension HomeViewController: HomeDisplayable {
    
    func displayLatestPosts(with viewModels: [PostsDataViewModel]) {
        latestPostsCollectionViewAdapter.reloadData(with: viewModels)
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
    
    func displayToggleFavorite(with viewModel: HomeModels.FavoriteViewModel) {
        // Nothing to do
    }
}

// MARK: - Interactions

private extension HomeViewController {
    
    @IBAction func popularPostsSeeAllButtonTapped() {
        router.listPosts(for: .popular)
    }
    
    @IBAction func topPickedPostsSeeAllButtonTapped() {
        router.listPosts(for: .picks)
    }
    
    @IBAction func topTermsSeeAllButtonTapped(_ sender: Any) {
        router.listTerms()
    }
    
    @IBAction func disclaimerButtonTapped() {
        guard let disclaimerURL = constants.disclaimerURL else {
            return present(
                alert: .localized(.disclaimerNotAvailableErrorTitle),
                message: .localized(.disclaimerNotAvailableErrorMessage)
            )
        }
        
        show(safari: disclaimerURL, theme: dependencies.resolve())
    }
    
    @IBAction func privacyButtonTapped() {
        show(safari: constants.privacyURL, theme: dependencies.resolve())
    }
    
    @IBAction func contactButtonTapped() {
        guard let controller = mailComposer.makeViewController(email: constants.email) else {
            return present(
                alert: .localized(.couldNotSendEmail),
                message: .localized(.couldNotSendEmailMessage)
            )
        }
        
        present(controller, animated: true)
    }
}

// MARK: - Delegates

extension HomeViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router.showPost(for: model)
    }
    
    func postsDataView(toggleFavorite model: PostsDataViewModel) {
        interactor.toggleFavorite(
            with: HomeModels.FavoriteRequest(
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

extension HomeViewController: TermsDataViewDelegate {
    
    func termsDataView(didSelect model: TermsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router.listPosts(for: .terms([model.id]))
    }
}

extension HomeViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let collectionView = previewingContext.sourceView as? UICollectionView,
            let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath) else {
                return nil
        }
        
        previewingContext.sourceRect = cell.frame
        
        let viewModel: PostsDataViewModel
        switch collectionView {
        case latestPostsCollectionView:
            viewModel = latestPostsCollectionViewAdapter.viewModels[indexPath.row]
        case popularPostsCollectionView:
            viewModel = popularPostsCollectionViewAdapter.viewModels[indexPath.row]
        case pickedPostsCollectionView:
            viewModel = pickedPostsCollectionViewAdapter.viewModels[indexPath.row]
        default:
            return nil
        }
        
        return router.previewPost(for: viewModel)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let previewController = viewControllerToCommit as? PreviewPostViewController else { return }
        router.showPost(for: previewController.viewModel)
    }
}

extension HomeViewController: Scrollable {
    
    func scrollToTop(animated: Bool) {
        guard isViewLoaded else { return }
        scrollView?.scrollToTop(animated: animated)
    }
    
    func scrollToBottom(animated: Bool) {
        guard isViewLoaded else { return }
        scrollView?.scrollToBottom(animated: animated)
    }
}

