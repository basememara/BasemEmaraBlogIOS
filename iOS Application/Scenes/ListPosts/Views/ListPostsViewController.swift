//
//  ListPostsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SystemConfiguration
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ListPostsViewController: UIViewController {
    
    // MARK: - Controls
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(PostTableViewCell.self)
            tableView.contentInset.bottom += 20
        }
    }
    
    // MARK: - Dependencies
    
    var core: ListPostsCoreType?
    
    private lazy var action: ListPostsActionable? = core?.action(with: self)
    private lazy var router: ListPostsRouterable? = core?.router(
        viewController: self,
        listPostsDelegate: delegate
    )
    
    private lazy var constants: ConstantsType? = core?.constants()
    private lazy var theme: Theme? = core?.theme()
    
    // MARK: - State
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    var params = ListPostsAPI.Params(
        fetchType: .latest,
        title: nil
    )
    
    weak var delegate: ListPostsDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
}

// MARK: - Setup

private extension ListPostsViewController {
    
    func configure() {
        if let title = params.title {
            self.title = title
        } else {
            switch params.fetchType {
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
    }
    
    func loadData() {
        switch params.fetchType {
        case .latest:
            action?.fetchLatestPosts(
                with: ListPostsAPI.FetchPostsRequest(
                    sort: params.sort
                )
            )
        case .popular:
            action?.fetchPopularPosts(
                with: ListPostsAPI.FetchPostsRequest(
                    sort: params.sort
                )
            )
        case .picks:
            action?.fetchTopPickPosts(
                with: ListPostsAPI.FetchPostsRequest(
                    sort: params.sort
                )
            )
        case .terms(let ids):
            action?.fetchPostsByTerms(
                with: ListPostsAPI.FetchPostsByTermsRequest(
                    ids: ids,
                    sort: params.sort
                )
            )
        }
    }
}

// MARK: - Scene

extension ListPostsViewController: ListPostsDisplayable {
    
    func displayPosts(with viewModels: [PostsDataViewModel]) {
        tableViewAdapter.reloadData(with: viewModels)
    }
    
    func displayToggleFavorite(with viewModel: ListPostsAPI.FavoriteViewModel) {
        // Nothing to do
    }
}

// MARK: - Delegates

extension ListPostsViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router?.showPost(for: model)
    }
    
    func postsDataView(trailingSwipeActionsFor model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? {
        guard let isFavorite = action?.isFavorite(postID: model.id) else { return nil }
        
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(style: .normal, title: isFavorite ? .localized(.unfavorTitle) : .localized(.favoriteTitle)) { _, _, completion in
                    self.action?.toggleFavorite(with: ListPostsAPI.FavoriteRequest(postID: model.id))
                    tableView.reloadRows(at: [indexPath], with: .none)
                    completion(true)
                }
                .with {
                    $0.image = UIImage(named: isFavorite ? .favoriteEmpty : .favoriteFilled)
                    $0.backgroundColor ?= theme?.tint
                }
            ]
        )
    }
}

@available(iOS 13, *)
extension ListPostsViewController {
    
    func postsDataView(contextMenuConfigurationFor model: PostsDataViewModel, at indexPath: IndexPath, point: CGPoint, from dataView: DataViewable) -> UIContextMenuConfiguration? {
        guard let constants = constants, let theme = theme else { return nil }
        return UIContextMenuConfiguration(for: model, at: indexPath, from: dataView, delegate: self, constants: constants, theme: theme)
    }
    
    func postsDataView(didPerformPreviewActionFor model: PostsDataViewModel, from dataView: DataViewable) {
        router?.showPost(for: model)
    }
}
