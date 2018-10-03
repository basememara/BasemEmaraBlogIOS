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

class HomeViewController: UIViewController, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet weak var popularTitleLabel: UILabel!
    @IBOutlet weak var tagTitleLabel: UILabel!
    @IBOutlet weak var picksTitleLabel: UILabel!
    
    @IBOutlet weak var latestPostsCollectionView: UICollectionView! {
        didSet { latestPostsCollectionView.register(nib: LatestPostCollectionViewCell.self) }
    }
    
    @IBOutlet weak var popularPostsCollectionView: UICollectionView! {
        didSet { popularPostsCollectionView.register(nib: PopularPostCollectionViewCell.self) }
    }
    
    @IBOutlet weak var pickedPostsCollectionView: UICollectionView! {
        didSet { pickedPostsCollectionView.register(nib: PickedPostCollectionViewCell.self) }
    }
    
    @IBOutlet weak var topTermsTableView: UITableView! {
        didSet { topTermsTableView.register(nib: TermTableViewCell.self) }
    }
    
    // MARK: - Scene variables
    
    private lazy var interactor: HomeBusinessLogic = HomeInteractor(
        presenter: HomePresenter(viewController: self),
        postsWorker: dependencies.resolveWorker(),
        mediaWorker: dependencies.resolveWorker(),
        taxonomyWorker: dependencies.resolveWorker()
    )
    
    private lazy var router: HomeRoutable = HomeRouter(
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
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
}

// MARK: - Events

private extension HomeViewController {
    
    func configure() {
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
}

// MARK: - Delegates

extension HomeViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router.showPost(for: model)
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
