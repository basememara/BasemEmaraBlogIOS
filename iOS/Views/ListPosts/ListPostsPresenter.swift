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
    private let state: Reduce<ListPostsReducer>
    private let dateFormatter: DateFormatter
    
    init(state: @escaping Reduce<ListPostsReducer>) {
        self.state = state
        self.dateFormatter = DateFormatter(dateStyle: .medium)
    }
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
        
        state(.loadPosts(viewModels))
    }
}

extension ListPostsPresenter {
    
    func displayLatestPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        state(.loadError(viewModel))
    }
    
    func displayPopularPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        state(.loadError(viewModel))
    }
    
    func displayTopPickPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        state(.loadError(viewModel))
    }
    
    func displayPostsByTerms(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.postsByTermsErrorTitle),
            message: error.localizedDescription
        )
        
        state(.loadError(viewModel))
    }
}

extension ListPostsPresenter {
    
    func displayToggleFavorite(for response: ListPostsAPI.FavoriteResponse) {
        let viewModel = ListPostsAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        state(.toggleFavorite(viewModel))
    }
}
