//
//  ListFavoritesInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI

// Scene namespace
enum ListFavoritesAPI {}

protocol ListFavoritesBusinessLogic: AppActionable {
    func fetchFavoritePosts(with request: ListFavoritesAPI.FetchPostsRequest)
    func toggleFavorite(with request: ListFavoritesAPI.FavoriteRequest)
}

protocol ListFavoritesPresentable: AppPresentable {
    func presentFavoritePosts(for response: ListFavoritesAPI.FetchPostsResponse)
    func presentFavoritePosts(error: DataError)
    
    func presentToggleFavorite(for response: ListFavoritesAPI.FavoriteResponse)
}

protocol ListFavoritesDisplayable: class, AppDisplayable {
    func displayPosts(with viewModels: [PostsDataViewModel])
    func displayToggleFavorite(with viewModel: ListFavoritesAPI.FavoriteViewModel)
}

protocol ListFavoritesRoutable: AppRoutable {
    func showPost(for model: PostsDataViewModel)
    func previewPost(for model: PostsDataViewModel) -> UIViewController?
}

extension ListFavoritesAPI {
    
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
