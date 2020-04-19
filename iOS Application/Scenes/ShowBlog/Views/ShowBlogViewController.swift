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
    private var token: NotificationCenter.Token?
    var store: Store<ShowBlogState>!
    var interactor: ShowBlogInteractorType?
    var render: ShowBlogRenderType?
    var constants: ConstantsType?
    var theme: Theme?
    
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
    
    // MARK: - Initializers
    
//    init(store: Store<ShowBlogState>, interactor: ShowBlogInteractorType?) {
//        self.store = store
//        self.interactor = interactor
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
}

// MARK: - Setup

private extension ShowBlogViewController {
    
    func prepare() {
        navigationItem.titleView = titleView
        navigationController?.navigationBar.prefersLargeTitles = false
        
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
        
        store(in: &token, observer: load)
        
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
        
        endRefreshing()
    }
}

// MARK: - Interactions

private extension ShowBlogViewController {
    
    @IBAction func popularPostsSeeAllButtonTapped() {
        render?.listPosts(
            params: ListPostsAPI.Params(fetchType: .popular)
        )
    }
    
    @IBAction func topPickedPostsSeeAllButtonTapped() {
        render?.listPosts(
            params: ListPostsAPI.Params(fetchType: .picks)
        )
    }
    
    @IBAction func topTermsSeeAllButtonTapped(_ sender: Any) {
        render?.listTerms()
    }
    
    @IBAction func disclaimerButtonTapped() {
        render?.showDisclaimer(url: constants?.disclaimerURL)
    }
    
    @IBAction func privacyButtonTapped() {
        render?.show(url: constants?.privacyURL)
    }
    
    @IBAction func contactButtonTapped() {
        render?.sendEmail(to: constants?.email)
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
        scrollView?.scrollToTop()
    }
}

// MARK: - Helpers

private extension ShowBlogViewController {
    
    func endRefreshing() {
        activityIndicatorView.stopAnimating()
    }
}
