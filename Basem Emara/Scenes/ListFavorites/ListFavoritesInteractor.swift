//
//  ListFavoritesInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListFavoritesInteractor: ListFavoritesBusinessLogic {
    private let presenter: ListFavoritesPresentable
    private let postWorker: PostWorkerType
    private let mediaWorker: MediaWorkerType
    
    init(
        presenter: ListFavoritesPresentable,
        postWorker: PostWorkerType,
        mediaWorker: MediaWorkerType
    ) {
        self.presenter = presenter
        self.postWorker = postWorker
        self.mediaWorker = mediaWorker
    }
}

extension ListFavoritesInteractor {
    
    func fetchFavoritePosts(with request: ListFavoritesAPI.FetchPostsRequest) {
        postWorker.fetchFavorites {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentFavoritePosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentFavoritePosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentFavoritePosts(
                    for: ListFavoritesAPI.FetchPostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListFavoritesInteractor {
    
    func toggleFavorite(with request: ListFavoritesAPI.FavoriteRequest) {
        postWorker.toggleFavorite(id: request.postID)
        
        presenter.presentToggleFavorite(
            for: ListFavoritesAPI.FavoriteResponse(
                postID: request.postID,
                favorite: postWorker.hasFavorite(id: request.postID)
            )
        )
    }
}
