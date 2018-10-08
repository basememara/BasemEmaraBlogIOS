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
import ZamzamKit

class ListPostsViewController: UIViewController, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: PostTableViewCell.self)
            tableView.contentInset.bottom += 20
        }
    }
    
    // MARK: - Scene variables
    
    private lazy var interactor: ListPostsBusinessLogic = ListPostsInteractor(
        presenter: ListPostsPresenter(viewController: self),
        postsWorker: dependencies.resolveWorker(),
        mediaWorker: dependencies.resolveWorker()
    )
    
    private lazy var router: ListPostsRoutable = ListPostsRouter(
        viewController: self
    )
    
    // MARK: - Internal variable
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    private lazy var constants: ConstantsType = dependencies.resolve()
    private lazy var theme: Theme = dependencies.resolve()
    
    var fetchType: FetchType = .latest
    weak var delegate: ShowPostViewControllerDelegate?
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
}

// MARK: - Events

private extension ListPostsViewController {
    
    func configure() {
        switch fetchType {
        case .latest:
            title = .localized(.latestPostsTitle)
        case .popular:
            title = .localized(.popularPostsTitle)
        case .picks:
            title = .localized(.topPicksTitle)
        case .terms:
            title = .localized(.postsByTermsTitle)
        }
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    func loadData() {
        switch fetchType {
        case .latest:
            interactor.fetchLatestPosts(
                with: ListPostsModels.FetchPostsRequest()
            )
        case .popular:
            interactor.fetchPopularPosts(
                with: ListPostsModels.FetchPostsRequest()
            )
        case .picks:
            interactor.fetchTopPickPosts(
                with: ListPostsModels.FetchPostsRequest()
            )
        case .terms(let ids):
            interactor.fetchPostsByTerms (
                with: ListPostsModels.FetchPostsByTermsRequest(ids: ids)
            )
        }
    }
}

// MARK: - Scene cycle

extension ListPostsViewController: ListPostsDisplayable {
    
    func displayPosts(with viewModels: [PostsDataViewModel]) {
        tableViewAdapter.reloadData(with: viewModels)
    }
    
    func displayToggleFavorite(with viewModel: ListPostsModels.FavoriteViewModel) {
        // Nothing to do
    }
}

// MARK: - Internal types

extension ListPostsViewController {
    
    enum FetchType {
        case latest
        case popular
        case picks
        case terms(Set<Int>)
    }
}

// MARK: - Delegates

extension ListPostsViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        guard let delegate = delegate else {
            // Pass data forward
            return router.showPost(for: model)
        }
        
        // Pass data back
        delegate.update(postID: model.id)
        router.dismiss()
    }
    
    func postsDataView(trailingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? {
        let isFavorite = interactor.isFavorite(postID: model.id)
        let sender = tableView.cellForRow(at: indexPath) ?? tableView
        
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(style: .normal, title: isFavorite ? .localized(.unfavorTitle) : .localized(.favoriteTitle)) { action, view, completion in
                    self.interactor.toggleFavorite(with: ListPostsModels.FavoriteRequest(postID: model.id))
                    tableView.reloadRows(at: [indexPath], with: .none)
                    completion(true)
                }.with {
                    $0.image = UIImage(named: isFavorite ? "favorite-empty" : "favorite-filled")
                    $0.backgroundColor = theme.tint
                },
                UIContextualAction(style: .normal, title: .localized(.moreTitle)) { action, view, completion in
                    self.present(
                        UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).with {
                            $0.addAction(
                                UIAlertAction(title: .localized(.commentsTitle)) {
                                    self.present(
                                        safari: self.constants.baseURL
                                            .appendingPathComponent("mobile-comments")
                                            .appendingQueryItem("postid", value: model.id)
                                            .absoluteString,
                                        theme: self.dependencies.resolve()
                                    )
                                }
                            )
                            
                            $0.addAction(
                                UIAlertAction(title: .localized(.shareTitle)) {
                                    let safariActivity = UIActivity.make(
                                        title: .localized(.openInSafari),
                                        imageName: "safari-share",
                                        imageBundle: .zamzamKit,
                                        handler: {
                                            guard let url = URL(string: model.link),
                                                SCNetworkReachability.isOnline else {
                                                    return self.present(
                                                        alert: .localized(.browserNotAvailableErrorTitle),
                                                        message: .localized(.notConnectedToInternetErrorMessage)
                                                    )
                                            }
                                            
                                            UIApplication.shared.open(url)
                                        }
                                    )
                                    
                                    self.present(
                                        activities: [model.title.htmlDecoded, model.link],
                                        popoverFrom: sender,
                                        applicationActivities: [safariActivity]
                                    )
                                }
                            )
                            
                            $0.addAction(
                                UIAlertAction(title: .localized(.cancel), style: .cancel)
                            )
                        },
                        popoverFrom: sender
                    )
                    
                    completion(true)
                }.with {
                    $0.image = UIImage(named: "more-icon")
                    $0.backgroundColor = theme.secondaryTint
                }
            ]
        )
    }
}

extension ListPostsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        return router.previewPost(for: tableViewAdapter.viewModels[indexPath.row])
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let previewController = viewControllerToCommit as? PreviewPostViewController else { return }
        router.showPost(for: previewController.viewModel)
    }
}
