//
//  FavoritesViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class ListFavoritesViewController: UIViewController, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: PostTableViewCell.self, inBundle: .swiftyPress)
            tableView.contentInset.bottom += 20
        }
    }
    
    @IBOutlet private var emptyPlaceholderView: UIView!
    
    // MARK: - Scene variables
    
    private lazy var interactor: ListFavoritesBusinessLogic = ListFavoritesInteractor(
        presenter: ListFavoritesPresenter(viewController: self),
        postWorker: dependencies.resolveWorker(),
        mediaWorker: dependencies.resolveWorker()
    )
    
    private lazy var router: ListFavoritesRoutable = ListFavoritesRouter(
        viewController: self
    )
    
    // MARK: - Internal variable
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    private var removedIDs = [Int]()
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
}

// MARK: - Events

private extension ListFavoritesViewController {
    
    func configure() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    func loadData() {
        interactor.fetchFavoritePosts(
            with: ListFavoritesModels.FetchPostsRequest()
        )
    }
}

// MARK: - Scene cycle

extension ListFavoritesViewController: ListFavoritesDisplayable {
    
    func displayPosts(with viewModels: [PostsDataViewModel]) {
        removedIDs.removeAll()
        tableViewAdapter.reloadData(with: viewModels)
    }
    
    func displayToggleFavorite(with viewModel: ListFavoritesModels.FavoriteViewModel) {
        removedIDs.append(viewModel.postID)
        
        let isEmpty = tableViewAdapter.viewModels
            .filter { !removedIDs.contains($0.id) }
            .isEmpty
        
        // Ensure empty screen to show if empty
        guard isEmpty else { return }
        loadData()
    }
}

// MARK: - Delegates

extension ListFavoritesViewController: PostsDataViewDelegate {
    
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int {
        let isEmpty = tableViewAdapter.viewModels.isEmpty
        tableView.backgroundView = isEmpty ? emptyPlaceholderView : nil
        tableView.separatorStyle = isEmpty ? .none : .singleLine
        return 1
    }
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router.showPost(for: model)
    }
    
    func postsDataView(trailingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(style: .destructive, title: .localized(.unfavorTitle)) { _, _, completion in
                    self.interactor.toggleFavorite(with: ListFavoritesModels.FavoriteRequest(postID: model.id))
                    completion(true)
                }.with {
                    $0.image = UIImage(named: "favorite-empty")
                }
            ]
        )
    }
}

extension ListFavoritesViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        return router.previewPost(for: tableViewAdapter.viewModels[indexPath.row])
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let viewModel = (viewControllerToCommit as? PreviewPostViewController)?.viewModel else { return }
        router.showPost(for: viewModel)
    }
}
