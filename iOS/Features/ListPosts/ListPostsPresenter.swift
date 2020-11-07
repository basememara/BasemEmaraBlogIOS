//
//  ListPostsPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateFormatter
import SwiftyPress
import ZamzamUI

struct ListPostsPresenter: ListPostsPresentable {
    var model: ListPostsState
    private let dateFormatter = DateFormatter(dateStyle: .medium)
}

extension ListPostsPresenter {
    
    func displayPosts(for response: ListPostsAPI.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                favorite: response.favoriteIDs.contains(post.id),
                dateFormatter: dateFormatter
            )
        }
        
        model.posts = viewModels
    }
}

extension ListPostsPresenter {
    
    func displayLatestPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        model.error = viewModel
    }
    
    func displayPopularPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        model.error = viewModel
    }
    
    func displayTopPickPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        model.error = viewModel
    }
    
    func displayPostsByTerms(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.postsByTermsErrorTitle),
            message: error.localizedDescription
        )
        
        model.error = viewModel
    }
}

extension ListPostsPresenter {
    
    func displayToggleFavorite(for response: ListPostsAPI.FavoriteResponse) {
        let viewModel = ListPostsAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        #warning("Implement favorites on global")
        //store(.toggleFavorite(viewModel))
    }
}
