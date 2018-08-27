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

class HomeViewController: UIViewController, HasDependencies { // TODO: Subclass for theme
    
    @IBOutlet weak var titleLabel: UILabel! { // TODO: Subclass for theme
        didSet { titleLabel.textColor = .white }
    }
    
    @IBOutlet weak var tagTitleLabel: UILabel! { // TODO: Subclass for theme
        didSet { tagTitleLabel.textColor = .white }
    }
    
    @IBOutlet weak var picksTitleLabel: UILabel! { // TODO: Subclass for theme
        didSet { picksTitleLabel.textColor = .white }
    }
    
    @IBOutlet weak var latestPostsCollectionView: UICollectionView! {
        didSet { latestPostsCollectionView.register(nib: LatestPostCollectionViewCell.self) }
    }
    
    @IBOutlet weak var popularPostsCollectionView: UICollectionView! {
        didSet { popularPostsCollectionView.register(nib: PopularPostCollectionViewCell.self) }
    }
    
    @IBOutlet weak var pickedPostsCollectionView: UICollectionView! {
        didSet { pickedPostsCollectionView.register(nib: PickedPostCollectionViewCell.self) }
    }
    
    @IBOutlet weak var topTermsTableView: UITableView!
    
    private lazy var interactor: HomeBusinessLogic = HomeInteractor(
        presenter: HomePresenter(viewController: self),
        postsWorker: dependencies.resolveWorker(),
        mediaWorker: dependencies.resolveWorker(),
        taxonomyWorker: dependencies.resolveWorker()
    )
    
    private lazy var latestPostsCollectionViewAdapter = PostsDataViewAdapter(
        delegate: self,
        for: latestPostsCollectionView
    )
    
    private lazy var popularPostsCollectionViewAdapter = PostsDataViewAdapter(
        delegate: self,
        for: popularPostsCollectionView
    )
    
    private lazy var pickedPostsCollectionViewAdapter = PostsDataViewAdapter(
        delegate: self,
        for: pickedPostsCollectionView
    )
    
    private lazy var topTermsTableViewAdapter = TermsDataViewAdapter(
        delegate: self,
        for: topTermsTableView
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UICollectionView.appearance().backgroundColor
        
        latestPostsCollectionView.collectionViewLayout = SnapPagingLayout(
            centerPosition: true,
            peekWidth: 40,
            spacing: 20,
            inset: 16
        )
        
        popularPostsCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
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
    
    @IBAction func popularPostsSeeAllButtonTapped() {
        let storyboard = UIStoryboard(name: "ListPosts")
        
        guard let controller = storyboard.instantiateInitialViewController() as? ListPostsViewController else {
            return
        }
        
        controller.fetchType = .popular
        
        show(controller, sender: nil)
    }
    
    @IBAction func topPickedPostsSeeAllButtonTapped() {
        let storyboard = UIStoryboard(name: "ListPosts")
        
        guard let controller = storyboard.instantiateInitialViewController() as? ListPostsViewController else {
            return
        }
        
        controller.fetchType = .picks
        
        show(controller, sender: nil)
    }
}

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

extension HomeViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        
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
        
    }
    
    func termsDataView(willDisplay model: TermsDataViewModel, in cell: UITableViewCell, at indexPath: IndexPath, from dataView: DataViewable) {
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
    }
}
