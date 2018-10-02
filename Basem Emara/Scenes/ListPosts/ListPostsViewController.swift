//
//  ListPostsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class ListPostsViewController: UIViewController, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: PostTableViewCell.self)
            
            // Add space to bottom
            tableView.contentInset.bottom += 20
        }
    }
    
    // MARK: - Scene variables
    
    private lazy var interactor: ListPostsBusinessLogic = ListPostsInteractor(
        presenter: ListPostsPresenter(viewController: self),
        postsWorker: dependencies.resolveWorker(),
        mediaWorker: dependencies.resolveWorker()
    )
    
    private lazy var router: ListPostsRoutable = ListPostsRouter(
        viewController: self
    )
    
    // MARK: - Internal variable
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    var fetchType: FetchType = .latest
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
}

// MARK: - Events

private extension ListPostsViewController {
    
    func configure() {
        switch fetchType {
        case .latest:
            title = .localized(.latestPostsTitle)
        case .popular:
            title = .localized(.popularPostsTitle)
        case .picks:
            title = .localized(.topPicksTitle)
        case .terms:
            title = .localized(.postsByTermsTitle)
        }
    }
    
    func loadData() {
        switch fetchType {
        case .latest:
            interactor.fetchLatestPosts(
                with: ListPostsModels.FetchPostsRequest()
            )
        case .popular:
            interactor.fetchPopularPosts(
                with: ListPostsModels.FetchPostsRequest()
            )
        case .picks:
            interactor.fetchTopPickPosts(
                with: ListPostsModels.FetchPostsRequest()
            )
        case .terms(let ids):
            interactor.fetchPostsByTerms (
                with: ListPostsModels.FetchPostsByTermsRequest(ids: ids)
            )
        }
    }
}

// MARK: - Scene cycle

extension ListPostsViewController: ListPostsDisplayable {
    
    func displayPosts(with viewModels: [PostsDataViewModel]) {
        tableViewAdapter.reloadData(with: viewModels)
    }
}

// MARK: - Internal types

extension ListPostsViewController {
    
    enum FetchType {
        case latest
        case popular
        case picks
        case terms(Set<Int>)
    }
}

// MARK: - Delegates

extension ListPostsViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router.showPost(for: model)
    }
}
