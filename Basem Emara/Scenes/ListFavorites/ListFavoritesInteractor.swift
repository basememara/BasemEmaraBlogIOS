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
    private let postsWorker: PostsWorkerType
    private let mediaWorker: MediaWorkerType
    
    init(presenter: ListFavoritesPresentable,
         postsWorker: PostsWorkerType,
         mediaWorker: MediaWorkerType) {
        self.presenter = presenter
        self.postsWorker = postsWorker
        self.mediaWorker = mediaWorker
    }
}

extension ListFavoritesInteractor {
    
    func fetchFavoritePosts(with request: ListFavoritesModels.FetchPostsRequest) {
        postsWorker.fetchFavorites {
            guard let posts = $0.value, $0.isSuccess else {
                return self.presenter.presentFavoritePosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else {
                    return self.presenter.presentFavoritePosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentFavoritePosts(
                    for: ListFavoritesModels.FetchPostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}
