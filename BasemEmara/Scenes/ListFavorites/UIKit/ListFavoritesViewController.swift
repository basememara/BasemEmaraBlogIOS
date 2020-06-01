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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingRemoved else { return }
        state.unsubscribe()
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
        
        // Bind reactive data
        state.subscribe(load)
    }
    
    func fetch() {
        interactor?.fetchFavoritePosts(
            with: ListFavoritesAPI.FetchPostsRequest()
        )
    }
    
    func load(_ result: StateChange<ListFavoritesState>) {
        switch result {
        case .updated(\ListFavoritesState.favorites), .initial:
            tableViewAdapter.reloadData(with: state.favorites)
        case .failure(let error):
            present(alert: error.title, message: error.message)
        default:
            break
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

// MARK: - Preview

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct ListFavoritesController_Preview: PreviewProvider {
    
    static var previews: some View {
        UINavigationController(
            rootViewController: ListFavoritesViewController(
                state: AppPreview.listFavoritesState,
                interactor: nil,
                render: nil,
                constants: AppPreview.core.constants(),
                theme: AppPreview.core.theme()
            )
        )
        .apply { $0.navigationBar.prefersLargeTitles = true }
        .previews
    }
}
#endif
