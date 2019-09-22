//
//  ListPostsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SystemConfiguration
import SwiftyPress
import ZamzamUI

class ListPostsViewController: UIViewController {
    
    // MARK: - Controls
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: PostTableViewCell.self)
            tableView.contentInset.bottom += 20
        }
    }
    
    // MARK: - Scene variables
    
    private lazy var action: ListPostsActionable = module.resolve(with: self)
    private lazy var router: ListPostsRoutable = module.resolve(with: self)
    
    // MARK: - Internal variable
    
    @Inject private var module: ListPostsModuleType
    @Inject private var constants: ConstantsType
    @Inject private var theme: Theme
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    var params = ListPostsAPI.Params(
        fetchType: .latest,
        title: nil
    )
    
    weak var delegate: ListPostsDelegate?
    
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
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    func loadData() {
        switch params.fetchType {
        case .latest:
            action.fetchLatestPosts(
                with: ListPostsAPI.FetchPostsRequest(
                    sort: params.sort
                )
            )
        case .popular:
            action.fetchPopularPosts(
                with: ListPostsAPI.FetchPostsRequest(
                    sort: params.sort
                )
            )
        case .picks:
            action.fetchTopPickPosts(
                with: ListPostsAPI.FetchPostsRequest(
                    sort: params.sort
                )
            )
        case .terms(let ids):
            action.fetchPostsByTerms(
                with: ListPostsAPI.FetchPostsByTermsRequest(
                    ids: ids,
                    sort: params.sort
                )
            )
        }
    }
}

// MARK: - Scene cycle

extension ListPostsViewController: ListPostsDisplayable {
    
    func displayPosts(with viewModels: [PostsDataViewModel]) {
        tableViewAdapter.reloadData(with: viewModels)
    }
    
    func displayToggleFavorite(with viewModel: ListPostsAPI.FavoriteViewModel) {
        // Nothing to do
    }
}

// MARK: - Delegates

extension ListPostsViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        delegate?.listPosts(self, didSelect: model.id) // Pass data back
            ?? router.showPost(for: model) // Pass data forward
    }
    
    func postsDataView(trailingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? {
        let isFavorite = action.isFavorite(postID: model.id)
        let sender = tableView.cellForRow(at: indexPath) ?? tableView
        
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(style: .normal, title: isFavorite ? .localized(.unfavorTitle) : .localized(.favoriteTitle)) { _, _, completion in
                    self.action.toggleFavorite(with: ListPostsAPI.FavoriteRequest(postID: model.id))
                    tableView.reloadRows(at: [indexPath], with: .none)
                    completion(true)
                }.with {
                    $0.image = UIImage(named: isFavorite ? .favoriteEmpty : .favoriteFilled)
                    $0.backgroundColor = theme.tint
                },
                UIContextualAction(style: .normal, title: .localized(.moreTitle)) { _, _, completion in
                    self.present(
                        actionSheet: nil,
                        popoverFrom: sender,
                        additionalActions: [
                            UIAlertAction(title: .localized(.commentsTitle)) {
                                self.present(
                                    safari: self.constants.baseURL
                                        .appendingPathComponent("mobile-comments")
                                        .appendingQueryItem("postid", value: model.id)
                                        .absoluteString,
                                    theme: self.theme
                                )
                            },
                            UIAlertAction(title: .localized(.shareTitle)) {
                                let safariActivity = UIActivity.make(
                                    title: .localized(.openInSafari),
                                    imageName: UIImage.ImageName.safariShare.rawValue,
                                    handler: {
                                        guard let url = URL(string: model.link),
                                            SCNetworkReachability.isOnline else {
                                                self.present(
                                                    alert: .localized(.browserNotAvailableErrorTitle),
                                                    message: .localized(.notConnectedToInternetErrorMessage)
                                                )
                                                
                                                return
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
                        ],
                        includeCancelAction: true
                    )
                    
                    completion(true)
                }.with {
                    $0.image = UIImage(named: .more)
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
        
        guard let models = tableViewAdapter.viewModels?[indexPath.row] else { return nil }
        return router.previewPost(for: models)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let viewModel = (viewControllerToCommit as? PreviewPostViewController)?.viewModel else { return }
        router.showPost(for: viewModel)
    }
}
