//
//  ListFavoritesInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol ListFavoritesInteractorType: InteractorType {
    func fetchFavoritePosts(with request: ListFavoritesAPI.FetchPostsRequest)
    func toggleFavorite(with request: ListFavoritesAPI.FavoriteRequest)
}

protocol ListFavoritesPresenterType: PresenterType {
    func displayFavoritePosts(for response: ListFavoritesAPI.FetchPostsResponse)
    func displayFavoritePosts(error: DataError)
    
    func displayToggleFavorite(for response: ListFavoritesAPI.FavoriteResponse)
}

protocol ListFavoritesRenderType: RenderType {
    func showPost(for model: PostsDataViewModel)
}

// MARK: - Namespace

enum ListFavoritesAPI {
    
    struct FetchPostsRequest {
        
    }
    
    struct FavoriteRequest {
        let postID: Int
    }
    
    struct FetchPostsResponse {
        let posts: [PostType]
        let media: [MediaType]
    }
    
    struct FavoriteResponse {
        let postID: Int
        let favorite: Bool
    }
    
    struct FavoriteViewModel {
        let postID: Int
        let favorite: Bool
    }
}
