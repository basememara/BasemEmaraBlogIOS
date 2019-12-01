//
//  ListFavoritesAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListFavoritesAction: ListFavoritesActionable {
    private let presenter: ListFavoritesPresentable
    private let postProvider: PostProviderType
    private let mediaProvider: MediaProviderType
    
    init(
        presenter: ListFavoritesPresentable,
        postProvider: PostProviderType,
        mediaProvider: MediaProviderType
    ) {
        self.presenter = presenter
        self.postProvider = postProvider
        self.mediaProvider = mediaProvider
    }
}

extension ListFavoritesAction {
    
    func fetchFavoritePosts(with request: ListFavoritesAPI.FetchPostsRequest) {
        postProvider.fetchFavorites {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentFavoritePosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaProvider.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
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

extension ListFavoritesAction {
    
    func toggleFavorite(with request: ListFavoritesAPI.FavoriteRequest) {
        postProvider.toggleFavorite(id: request.postID)
        
        presenter.presentToggleFavorite(
            for: ListFavoritesAPI.FavoriteResponse(
                postID: request.postID,
                favorite: postProvider.hasFavorite(id: request.postID)
            )
        )
    }
}
