//
//  SearchPostsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Combine
import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

final class SearchPostsViewController: UIViewController {
    private let state: SearchPostsState
    private let interactor: SearchPostsInteractable?
    private var render: SearchPostsRenderable?
    private let constants: Constants
    private let theme: Theme
    private var cancellable = Set<AnyCancellable>()
    
    var searchText: String?
    
    // MARK: - Controls

    private lazy var tableView = UITableView().apply {
        $0.register(SimplePostTableViewCell.self)
        $0.contentInset.bottom += 20
    }
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    private lazy var searchController = UISearchController(searchResultsController: nil).apply {
        $0.searchResultsUpdater = self
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.delegate = self
        $0.searchBar.placeholder = .localized(.searchPlaceholder)
        $0.searchBar.scopeButtonTitles = [
            .localized(.searchAllScope),
            .localized(.searchTitleScope),
            .localized(.searchContentScope),
            .localized(.searchKeywordsScope)
        ]
    }
    
    private lazy var emptyPlaceholderView = EmptyPlaceholderView(
        text: .localized(.emptySearchMessage)
    )
    
    // MARK: - Initializers
    
    init(
        state: SearchPostsState,
        interactor: SearchPostsInteractable?,
        render: ((UIViewController) -> SearchPostsRenderable)?,
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
        observe()
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingRemoved else { return }
        cancellable.removeAll()
    }
}

// MARK: - Setup

private extension SearchPostsViewController {
    
    func prepare() {
        // Configure controls
        definesPresentationContext = true
        navigationItem.title = .localized(.search)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
    }
    
    func observe() {
        state.$posts
            .compactMap { $0 }
            .sink(receiveValue: tableViewAdapter.reloadData)
            .store(in: &cancellable)
        
        state.$error
            .sink(receiveValue: load)
            .store(in: &cancellable)
    }
}

extension SearchPostsViewController {
    
    func fetch() {
        guard let searchText = searchText else {
            interactor?.fetchPopularPosts(
                with: SearchPostsAPI.PopularRequest()
            )
            
            return
        }
        
        self.searchText = nil
        searchController.isActive = true
        searchController.searchBar.text = searchText
        search(for: searchText, with: 0)
    }
}

private extension SearchPostsViewController {
    
    func search(for text: String, with scope: Int) {
        interactor?.fetchSearchResults(
            with: PostAPI.SearchRequest(
                query: text,
                scope: {
                    switch scope {
                    case 1:
                        return .title
                    case 2:
                        return .content
                    case 3:
                        return .terms
                    default:
                        return .all
                    }
                }()
            )
        )
    }
}

private extension SearchPostsViewController {
    
    func load(error: ViewError?) {
        guard let error = error else { return }
        present(alert: error.title, message: error.message)
    }
}

// MARK: - Delegates

extension SearchPostsViewController: UISearchResultsUpdating {
    private static var searchLimiter = Debouncer(limit: 0.5)
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            fetch()
            return
        }
        
        // Skip irrelevant search until some characters
        guard text.count > 1 else { return }
        
        SearchPostsViewController.searchLimiter.execute { [weak self] in
            self?.search(
                for: text,
                with: searchController.searchBar.selectedScopeButtonIndex
            )
        }
    }
}

extension SearchPostsViewController: PostsDataViewDelegate {
    
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int {
        let isEmpty = tableViewAdapter.viewModels?.isEmpty == true
        tableView.backgroundView = isEmpty ? emptyPlaceholderView : nil
        tableView.separatorStyle = isEmpty ? .none : .singleLine
        return 1
    }
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        render?.showPost(for: model)
    }
}

extension SearchPostsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        search(for: text, with: selectedScope)
    }
}

@available(iOS 13, *)
extension SearchPostsViewController {
    
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
struct SearchPostsControllerPreview: PreviewProvider {
    
    static var previews: some View {
        UINavigationController(
            rootViewController: SearchPostsViewController(
                state: Preview.searchPostsState,
                interactor: nil,
                render: nil,
                constants: Preview.core.constants(),
                theme: Preview.core.theme()
            )
        )
        .apply { $0.navigationBar.prefersLargeTitles = true }
        .previews
    }
}
#endif
