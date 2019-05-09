//
//  ListPostsInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListPostsInteractor: ListPostsBusinessLogic {
    private let presenter: ListPostsPresentable
    private let postWorker: PostWorkerType
    private let mediaWorker: MediaWorkerType
    
    init(presenter: ListPostsPresentable,
         postWorker: PostWorkerType,
         mediaWorker: MediaWorkerType) {
        self.presenter = presenter
        self.postWorker = postWorker
        self.mediaWorker = mediaWorker
    }
}

extension ListPostsInteractor {
    
    func fetchLatestPosts(with request: ListPostsModels.FetchPostsRequest) {
        postWorker.fetch {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentLatestPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentLatestPosts(
                    for: ListPostsModels.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func fetchPopularPosts(with request: ListPostsModels.FetchPostsRequest) {
        postWorker.fetchPopular {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentPopularPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentPopularPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentPopularPosts(
                    for: ListPostsModels.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func fetchTopPickPosts(with request: ListPostsModels.FetchPostsRequest) {
        postWorker.fetchTopPicks {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentTopPickPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentTopPickPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentTopPickPosts(
                    for: ListPostsModels.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func fetchPostsByTerms(with request: ListPostsModels.FetchPostsByTermsRequest) {
        postWorker.fetch(byTermIDs: request.ids) {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentPostsByTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentPostsByTerms(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentPostsByTerms(
                    for: ListPostsModels.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func toggleFavorite(with request: ListPostsModels.FavoriteRequest) {
        postWorker.toggleFavorite(id: request.postID)
        
        presenter.presentToggleFavorite(
            for: ListPostsModels.FavoriteResponse(
                postID: request.postID,
                favorite: postWorker.hasFavorite(id: request.postID)
            )
        )
    }
    
    func isFavorite(postID: Int) -> Bool {
        return postWorker.hasFavorite(id: postID)
    }
}
