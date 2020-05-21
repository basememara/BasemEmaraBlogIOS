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

final class ListFavoritesViewController: UIViewController {
    private let state: ListFavoritesState
    private let interactor: ListFavoritesInteractable?
    private var render: ListFavoritesRenderable?
    private let constants: Constants
    private let theme: Theme
    private var cancellable: NotificationCenter.Cancellable?

    // MARK: - Controls
    
    private lazy var tableView = UITableView().apply {
        $0.register(PostTableViewCell.self)
        $0.contentInset.bottom += 20
    }
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    private lazy var emptyPlaceholderView = EmptyPlaceholderView(
        text: .localized(.emptyFavoritesMessage)
    )
    
    // MARK: - Initializers
    
    init(
        state: ListFavoritesState,
        interactor: ListFavoritesInteractable?,
        render: ((UIViewController) -> ListFavoritesRenderable)?,
        constants: Constants,
        theme: Theme
    ) {
        self.state = state
        self.interactor = interactor
        self.constants = constants
        self.theme = theme
        
        super.init(nibName: nil, bundle: nil)
        self.render = render?(self)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        state.subscribe(load, in: &cancellable)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellable = nil
    }
}

// MARK: - Setup

private extension ListFavoritesViewController {
    
    func prepare() {
        // Configure controls
        navigationItem.title = .localized(.favoritesTitle)
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
    }
    
    func fetch() {
        interactor?.fetchFavoritePosts(
            with: ListFavoritesAPI.FetchPostsRequest()
        )
    }
    
    func load(_ keyPath: PartialKeyPath<ListFavoritesState>?) {
        if keyPath == \ListFavoritesState.favorites || keyPath == nil {
            tableViewAdapter.reloadData(with: state.favorites)
        }
        
        if keyPath == \ListFavoritesState.error {
            present(
                alert: state.error?.title,
                message: state.error?.message
            )
        }
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
        render?.showPost(for: model)
    }
    
    func postsDataView(trailingSwipeActionsFor model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(style: .destructive, title: .localized(.unfavorTitle)) { _, _, completion in
                    self.interactor?.toggleFavorite(with: ListFavoritesAPI.FavoriteRequest(postID: model.id))
                    completion(true)
                }
                .apply {
                    $0.image = UIImage(named: .favoriteEmpty)
                }
            ]
        )
    }
}

@available(iOS 13, *)
extension ListFavoritesViewController {
    
    func postsDataView(contextMenuConfigurationFor model: PostsDataViewModel, at indexPath: IndexPath, point: CGPoint, from dataView: DataViewable) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(for: model, at: indexPath, from: dataView, delegate: self, constants: constants, theme: theme)
    }
    
    func postsDataView(didPerformPreviewActionFor model: PostsDataViewModel, from dataView: DataViewable) {
        render?.showPost(for: model)
    }
}
