//
//  SearchPostsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress
import ZamzamCore
import ZamzamUI

class SearchPostsViewController: UIViewController {
    
    // MARK: - Controls

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: SimplePostTableViewCell.self)
            tableView.contentInset.bottom += 20
        }
    }
    
    private lazy var searchController = UISearchController(searchResultsController: nil).with {
        $0.searchResultsUpdater = self
        $0.dimsBackgroundDuringPresentation = false
        $0.searchBar.delegate = self
        $0.searchBar.placeholder = .localized(.searchPlaceholder)
        $0.searchBar.scopeButtonTitles = [
            .localized(.searchAllScope),
            .localized(.searchTitleScope),
            .localized(.searchContentScope),
            .localized(.searchKeywordsScope)
        ]
    }
    
    @IBOutlet private var emptyPlaceholderView: UIView!
    
    // MARK: - Dependencies
    
    @Inject private var module: SearchPostsModuleType
    
    private lazy var action: SearchPostsActionable = module.component(with: self)
    private lazy var router: SearchPostsRoutable = module.component(with: self)

    // MARK: - State
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    var searchText: String?
    
    // MARK: - Controller cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
}

// MARK: - Setup

extension SearchPostsViewController {
    
    private func configure() {
        // Handles switching tabs while focused
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    public func loadData() {
        guard let searchText = searchText else {
            return action.fetchPopularPosts(
                with: SearchPostsAPI.PopularRequest()
            )
        }
        
        self.searchText = nil
        searchController.isActive = true
        searchController.searchBar.text = searchText
        searchData(for: searchText, with: 0)
    }
    
    private func searchData(for text: String, with scope: Int) {
        action.fetchSearchResults(
            with: PostsAPI.SearchRequest(
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

// MARK: - Scene

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
        let isEmpty = tableViewAdapter.viewModels?.isEmpty == true
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
        guard let text = searchController.searchBar.text else { return }
        searchData(for: text, with: selectedScope)
    }
}

extension SearchPostsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        
        guard let models = tableViewAdapter.viewModels?[indexPath.row] else { return nil }
        return router.previewPost(for: models)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let viewModel = (viewControllerToCommit as? PreviewPostViewController)?.viewModel else { return }
        router.showPost(for: viewModel)
    }
}
