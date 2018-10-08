//
//  SearchPostsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class SearchPostsViewController: UIViewController, HasDependencies {
    
    // MARK: - Controls

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: SimplePostTableViewCell.self)
            tableView.contentInset.bottom += 20
        }
    }
    
    private lazy var searchController = UISearchController(searchResultsController: nil).with {
        $0.searchResultsUpdater = self
        $0.searchBar.delegate = self
        $0.searchBar.placeholder = .localized(.searchPlaceholder)
        $0.searchBar.scopeButtonTitles = [
            .localized(.searchAllScope),
            .localized(.searchTitleScope),
            .localized(.searchContentScope),
            .localized(.searchKeywordsScope)
        ]
    }
    
    @IBOutlet var emptyPlaceholderView: UIView!
    
    // MARK: - Scene variables
    
    private lazy var interactor: SearchPostsBusinessLogic = SearchPostsInteractor(
        presenter: SearchPostsPresenter(viewController: self),
        postsWorker: dependencies.resolveWorker(),
        mediaWorker: dependencies.resolveWorker()
    )
    
    private lazy var router: SearchPostsRoutable = SearchPostsRouter(
        viewController: self
    )

    // MARK: - Internal variables
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    // MARK: - Controller cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
}

// MARK: - Events

private extension SearchPostsViewController {
    
    func configure() {
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableViewAdapter.reloadData(with: [])
    }
    
    func loadData() {
        interactor.fetchPopularPosts(
            with: SearchPostsModels.PopularRequest()
        )
    }
    
    func searchData(for text: String, with scope: Int) {
        interactor.fetchSearchResults(
            with: PostsModels.SearchRequest(
                query: text,
                scope: {
                    switch scope {
                    case 1: return .title
                    case 2: return .content
                    case 3: return .terms
                    default: return .all
                    }
                }()
            )
        )
    }
}

// MARK: - Scene cycle

extension SearchPostsViewController: SearchPostsDisplayable {

    func displayPosts(with viewModels: [PostsDataViewModel]) {
        tableViewAdapter.reloadData(with: viewModels)
    }
}

// MARK: - Delegates

extension SearchPostsViewController: UISearchResultsUpdating {
    private static var searchLimiter = Debouncer(limit: 0.5)
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return loadData()
        }
        
        // Skip irrelevant search until some characters
        guard text.count > 1 else { return }
        
        SearchPostsViewController.searchLimiter.execute { [weak self] in
            self?.searchData(
                for: text,
                with: searchController.searchBar.selectedScopeButtonIndex
            )
        }
    }
}

extension SearchPostsViewController: PostsDataViewDelegate {
    
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int {
        let isEmpty = tableViewAdapter.viewModels.isEmpty
        tableView.backgroundView = isEmpty ? emptyPlaceholderView : nil
        tableView.separatorStyle = isEmpty ? .none : .singleLine
        return 1
    }
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router.showPost(for: model)
    }
}

extension SearchPostsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchData(for: searchController.searchBar.text!, with: selectedScope)
    }
}
