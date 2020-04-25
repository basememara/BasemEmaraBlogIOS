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
    private let store: Store<ListFavoritesState>
    private let interactor: ListFavoritesInteractorType?
    private let constants: ConstantsType
    private let theme: Theme
    private var token: NotificationCenter.Token?
    
    var render: ListFavoritesRenderType?

    // MARK: - Controls
    
    private lazy var tableView = UITableView().with {
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
        store: Store<ListFavoritesState>,
        interactor: ListFavoritesInteractorType?,
        constants: ConstantsType,
        theme: Theme
    ) {
        self.store = store
        self.interactor = interactor
        self.constants = constants
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
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
        
        // Bind state
        store(in: &token, observer: load)
    }
    
    func fetch() {
        interactor?.fetchFavoritePosts(
            with: ListFavoritesAPI.FetchPostsRequest()
        )
    }
    
    func load(_ state: ListFavoritesState) {
        tableViewAdapter.reloadData(with: state.favorites)
        
        // TODO: Handle error
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
                .with {
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
