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
    
    private lazy var postsWorker: PostsWorkerType = dependencies.resolveWorker()
    private lazy var mediaWorker: MediaWorkerType = dependencies.resolveWorker()
    private lazy var taxonomyWorker: TaxonomyWorkerType = dependencies.resolveWorker()
    
    private lazy var dateFormatter = DateFormatter().with {
        $0.dateStyle = .medium
        $0.timeStyle = .none
        $0.locale = .posix
    }
    
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
        
        postsWorker.fetch { [unowned self] in
            guard let posts = $0.value, $0.isSuccess else { return }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else { return }
            
                let models = posts.prefix(30).map { post in
                    PostsDataViewModel(
                        id: post.id,
                        title: post.title,
                        summary: !post.excerpt.isEmpty ? post.excerpt
                            : post.content.prefix(150).string.htmlStripped.htmlDecoded,
                        date: self.dateFormatter.string(from: post.createdAt),
                        imageURL: media.first { $0.id == post.mediaID }?.link
                    )
                }
                
                self.latestPostsCollectionViewAdapter.reloadData(with: models)
            }
        }
        
        postsWorker.fetchPopular { [unowned self] in
            guard let posts = $0.value, $0.isSuccess else { return }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else { return }
                
                let models = posts.prefix(30).map { post in
                    PostsDataViewModel(
                        id: post.id,
                        title: post.title,
                        summary: !post.excerpt.isEmpty ? post.excerpt
                            : post.content.prefix(150).string.htmlStripped.htmlDecoded,
                        date: self.dateFormatter.string(from: post.createdAt),
                        imageURL: media.first { $0.id == post.mediaID }?.link
                    )
                }
                
                self.popularPostsCollectionViewAdapter.reloadData(with: models)
            }
        }
        
        postsWorker.fetchTopPicks { [unowned self] in
            guard let posts = $0.value, $0.isSuccess else { return }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else { return }
                
                let models = posts.prefix(30).map { post in
                    PostsDataViewModel(
                        id: post.id,
                        title: post.title,
                        summary: !post.excerpt.isEmpty ? post.excerpt
                            : post.content.prefix(150).string.htmlStripped.htmlDecoded,
                        date: self.dateFormatter.string(from: post.createdAt),
                        imageURL: media.first { $0.id == post.mediaID }?.link
                    )
                }
                
                self.pickedPostsCollectionViewAdapter.reloadData(with: models)
            }
        }
        
        taxonomyWorker.fetch { [unowned self] in
            guard let terms = $0.value?.sorted(by: { $0.count > $1.count }), $0.isSuccess else { return }
            
            let models = terms.prefix(6).map {
                TermsDataViewModel(
                    id: $0.id,
                    name: $0.name,
                    count: .localizedStringWithFormat("%d", $0.count),
                    taxonomy: $0.taxonomy
                )
            }
            
            self.topTermsTableViewAdapter.reloadData(with: models)
        }
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
