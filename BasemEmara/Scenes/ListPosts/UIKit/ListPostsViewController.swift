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

final class ListPostsViewController: UIViewController {
    private let state: ListPostsState
    private let interactor: ListPostsInteractable?
    private var render: ListPostsRenderable?
    private let constants: Constants
    private let theme: Theme
    
    var params = ListPostsAPI.Params(
        fetchType: .latest,
        title: nil
    )
    
    weak var delegate: ListPostsDelegate?
    
    // MARK: - Controls
    
    private lazy var tableView = UITableView().apply {
        $0.register(PostTableViewCell.self)
        $0.contentInset.bottom += 20
    }
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    private lazy var activityIndicatorView = tableView.makeActivityIndicator()
    
    // MARK: - Initializers
    
    init(
        state: ListPostsState,
        interactor: ListPostsInteractable?,
        render: ((UIViewController) -> ListPostsRenderable)?,
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

private extension ListPostsViewController {
    
    func prepare() {
        // Configure controls
        navigationItem.backBarButtonItem = .makeBackBarButtonItem()
        activityIndicatorView.startAnimating()
        
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
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
        
        // Bind reactive data
        state.subscribe(load)
    }
    
    func fetch() {
        switch params.fetchType {
        case .latest:
            interactor?.fetchLatestPosts(
                with: ListPostsAPI.FetchPostsRequest(
                    sort: params.sort
                )
            )
        case .popular:
            interactor?.fetchPopularPosts(
                with: ListPostsAPI.FetchPostsRequest(
                    sort: params.sort
                )
            )
        case .picks:
            interactor?.fetchTopPickPosts(
                with: ListPostsAPI.FetchPostsRequest(
                    sort: params.sort
                )
            )
        case .terms(let ids):
            interactor?.fetchPostsByTerms(
                with: ListPostsAPI.FetchPostsByTermsRequest(
                    ids: ids,
                    sort: params.sort
                )
            )
        }
    }
    
    func load(_ result: StateChange<ListPostsState>) {
        switch result {
        case .updated(\ListPostsState.posts), .initial:
            tableViewAdapter.reloadData(with: state.posts)
        case .failure(let error):
            present(alert: error.title, message: error.message)
        default:
            break
        }
        
        endRefreshing()
    }
}

// MARK: - Delegates

extension ListPostsViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        render?.showPost(for: model)
    }
    
    func postsDataView(trailingSwipeActionsFor model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(
                    style: model.favorite ? .destructive : .normal,
                    title: model.favorite ? .localized(.unfavorTitle) : .localized(.favoriteTitle),
                    handler: { _, _, completion in
                        self.interactor?.toggleFavorite(with: ListPostsAPI.FavoriteRequest(postID: model.id))
                        completion(true)
                    }
                ).apply {
                    $0.image = UIImage(named: model.favorite ? .favoriteEmpty : .favoriteFilled)
                    $0.backgroundColor = model.favorite ? theme.negativeColor : theme.tint
                }
            ]
        )
    }
}

@available(iOS 13, *)
extension ListPostsViewController {
    
    func postsDataView(contextMenuConfigurationFor model: PostsDataViewModel, at indexPath: IndexPath, point: CGPoint, from dataView: DataViewable) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(for: model, at: indexPath, from: dataView, delegate: self, constants: constants, theme: theme)
    }
    
    func postsDataView(didPerformPreviewActionFor model: PostsDataViewModel, from dataView: DataViewable) {
        render?.showPost(for: model)
    }
}

// MARK: - Helpers

private extension ListPostsViewController {
    
    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
            self?.activityIndicatorView.stopAnimating()
        }
    }
}

// MARK: - Preview

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct ListPostsController_Preview: PreviewProvider {
    
    static var previews: some View {
        UINavigationController(
            rootViewController: ListPostsViewController(
                state: AppPreview.listPostsState,
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
