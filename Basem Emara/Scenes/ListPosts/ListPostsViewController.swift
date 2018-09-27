//
//  ListPostsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class ListPostsViewController: UIViewController, HasDependencies {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: PostTableViewCell.self)
            
            // Add space to bottom
            tableView.contentInset.bottom += 20
        }
    }
    
    private lazy var tableViewAdapter = PostsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    private lazy var postsWorker: PostsWorkerType = dependencies.resolveWorker()
    private lazy var mediaWorker: MediaWorkerType = dependencies.resolveWorker()
    private lazy var taxonomyWorker: TaxonomyWorkerType = dependencies.resolveWorker()
    
    private lazy var dateFormatter = DateFormatter().with {
        $0.dateStyle = .medium
        $0.timeStyle = .none
    }
    
    var fetchType: FetchType = .latest
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let completion: ((Result<[PostType], DataError>) -> Void) = { [weak self] in
            guard let posts = $0.value, $0.isSuccess else { return }
            
            self?.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else { return }
                
                let models = posts.prefix(30).map { post in
                    PostsDataViewModel(
                        id: post.id,
                        title: post.title,
                        summary: !post.excerpt.isEmpty ? post.excerpt
                            : post.content.prefix(150).string.htmlStripped.htmlDecoded,
                        date: self?.dateFormatter.string(from: post.createdAt) ?? "",
                        imageURL: media.first { $0.id == post.mediaID }?.link
                    )
                }
                
                self?.tableViewAdapter.reloadData(with: models)
            }
        }
        
        switch fetchType {
        case .latest:
            postsWorker.fetch(completion: completion)
        case .popular:
            postsWorker.fetchPopular(completion: completion)
        case .picks:
            postsWorker.fetchTopPicks(completion: completion)
        }
    }
}

extension ListPostsViewController {
    
    enum FetchType {
        case latest
        case popular
        case picks
    }
}

extension ListPostsViewController: PostsDataViewDelegate {
    
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        
    }
}
