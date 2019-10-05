//
//  ListPostsAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListPostsAction: ListPostsActionable {
    private let presenter: ListPostsPresentable
    private let postWorker: PostWorkerType
    private let mediaWorker: MediaWorkerType
    
    init(
        presenter: ListPostsPresentable,
        postWorker: PostWorkerType,
        mediaWorker: MediaWorkerType
    ) {
        self.presenter = presenter
        self.postWorker = postWorker
        self.mediaWorker = mediaWorker
    }
}

extension ListPostsAction {
    
    func fetchLatestPosts(with request: ListPostsAPI.FetchPostsRequest) {
        let fetchRequest = PostsAPI.FetchRequest()
        
        postWorker.fetch(with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                return self.presenter.presentLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentLatestPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentLatestPosts(
                    for: ListPostsAPI.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsAction {
    
    func fetchPopularPosts(with request: ListPostsAPI.FetchPostsRequest) {
        let fetchRequest = PostsAPI.FetchRequest()
        
        postWorker.fetchPopular(with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                return self.presenter.presentPopularPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentPopularPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentPopularPosts(
                    for: ListPostsAPI.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsAction {
    
    func fetchTopPickPosts(with request: ListPostsAPI.FetchPostsRequest) {
        let fetchRequest = PostsAPI.FetchRequest()
        
        postWorker.fetchTopPicks(with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                return self.presenter.presentTopPickPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentTopPickPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentTopPickPosts(
                    for: ListPostsAPI.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsAction {
    
    func fetchPostsByTerms(with request: ListPostsAPI.FetchPostsByTermsRequest) {
        let fetchRequest = PostsAPI.FetchRequest()
        
        postWorker.fetch(byTermIDs: request.ids, with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                return self.presenter.presentPostsByTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentPostsByTerms(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentPostsByTerms(
                    for: ListPostsAPI.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsAction {
    
    func toggleFavorite(with request: ListPostsAPI.FavoriteRequest) {
        postWorker.toggleFavorite(id: request.postID)
        
        presenter.presentToggleFavorite(
            for: ListPostsAPI.FavoriteResponse(
                postID: request.postID,
                favorite: postWorker.hasFavorite(id: request.postID)
            )
        )
    }
    
    func isFavorite(postID: Int) -> Bool {
        postWorker.hasFavorite(id: postID)
    }
}
