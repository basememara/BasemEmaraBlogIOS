//
//  FavoritesViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ListFavoritesViewController: UIViewController {
    
    // MARK: - Controls
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: PostTableViewCell.self)
            tableView.contentInset.bottom += 20
        }
    }
    
    @IBOutlet private var emptyPlaceholderView: UIView!
    
    // MARK: - Dependencies
    
    var core: ListFavoritesCoreType?
    
    private lazy var action: ListFavoritesActionable? = core?.dependency(with: self)
    private lazy var router: ListFavoritesRouterable? = core?.dependency(with: self)
    
    private lazy var constants: ConstantsType? = core?.dependency()
    private lazy var theme: Theme? = core?.dependency()
    
    // MARK: - State
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    private var removedIDs: [Int] = []
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
}

// MARK: - Setup

private extension ListFavoritesViewController {
    
    func loadData() {
        action?.fetchFavoritePosts(
            with: ListFavoritesAPI.FetchPostsRequest()
        )
    }
}

// MARK: - Scene

extension ListFavoritesViewController: ListFavoritesDisplayable {
    
    func displayPosts(with viewModels: [PostsDataViewModel]) {
        removedIDs.removeAll()
        tableViewAdapter.reloadData(with: viewModels)
    }
    
    func displayToggleFavorite(with viewModel: ListFavoritesAPI.FavoriteViewModel) {
        removedIDs.append(viewModel.postID)
        
        let isEmpty = tableViewAdapter.viewModels?
            .filter { !removedIDs.contains($0.id) }
            .isEmpty ?? true
        
        // Ensure empty screen to show if empty
        guard isEmpty else { return }
        loadData()
    }
}

// MARK: - Delegates

extension ListFavoritesViewController: PostsDataViewDelegate {
    
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int {
        let isEmpty = tableViewAdapter.viewModels?.isEmpty == true
        tableView.backgroundView = isEmpty ? emptyPlaceholderView : nil
        tableView.separatorStyle = isEmpty ? .none : .singleLine
        return 1
    }
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router?.showPost(for: model)
    }
    
    func postsDataView(trailingSwipeActionsFor model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(style: .destructive, title: .localized(.unfavorTitle)) { _, _, completion in
                    self.action?.toggleFavorite(with: ListFavoritesAPI.FavoriteRequest(postID: model.id))
                    completion(true)
                }
                .with {
                    $0.image = UIImage(named: .favoriteEmpty)
                }
            ]
        )
    }
}

@available(iOS 13.0, *)
extension ListFavoritesViewController {
    
    func postsDataView(contextMenuConfigurationFor model: PostsDataViewModel, at indexPath: IndexPath, point: CGPoint, from dataView: DataViewable) -> UIContextMenuConfiguration? {
        guard let constants = constants, let theme = theme else { return nil }
        return UIContextMenuConfiguration(for: model, at: indexPath, from: dataView, delegate: self, constants: constants, theme: theme)
    }
    
    func postsDataView(didPerformPreviewActionFor model: PostsDataViewModel, from dataView: DataViewable) {
        router?.showPost(for: model)
    }
}
