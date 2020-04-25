//
//  ListFavoritesAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListFavoritesInteractor: ListFavoritesInteractorType {
    private let presenter: ListFavoritesPresenterType
    private let postRepository: PostRepositoryType
    private let mediaRepository: MediaRepositoryType
    
    init(
        presenter: ListFavoritesPresenterType,
        postRepository: PostRepositoryType,
        mediaRepository: MediaRepositoryType
    ) {
        self.presenter = presenter
        self.postRepository = postRepository
        self.mediaRepository = mediaRepository
    }
}

extension ListFavoritesInteractor {
    
    func fetchFavoritePosts(with request: ListFavoritesAPI.FetchPostsRequest) {
        postRepository.fetchFavorites {
            guard case .success(let posts) = $0 else {
                return self.presenter.displayFavoritePosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.displayFavoritePosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.displayFavoritePosts(
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
        postRepository.toggleFavorite(id: request.postID)
        
        presenter.displayToggleFavorite(
            for: ListFavoritesAPI.FavoriteResponse(
                postID: request.postID,
                favorite: postRepository.hasFavorite(id: request.postID)
            )
        )
    }
}
