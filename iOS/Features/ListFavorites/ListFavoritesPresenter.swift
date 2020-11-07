//
//  ListFavoritesPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateFormatter
import SwiftyPress
import ZamzamUI

struct ListFavoritesPresenter: ListFavoritesPresentable {
    var model: ListFavoritesState
    private let dateFormatter = DateFormatter(dateStyle: .medium)
}

extension ListFavoritesPresenter {
    
    func displayFavoritePosts(for response: ListFavoritesAPI.FetchPostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                favorite: true,
                dateFormatter: dateFormatter
            )
        }
        
        model.favorites = viewModels
    }
    
    func displayFavoritePosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        model.error = viewModel
    }
}

extension ListFavoritesPresenter {
    
    func displayToggleFavorite(for response: ListFavoritesAPI.FavoriteResponse) {
        let viewModel = ListFavoritesAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        #warning("Implement favorites on global")
        //store(.toggleFavorite(viewModel))
    }
}
