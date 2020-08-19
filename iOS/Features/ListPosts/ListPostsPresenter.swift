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
    private let store: StoreReducer<ListPostsReducer>
    private let dateFormatter: DateFormatter
    
    init(_ store: @escaping StoreReducer<ListPostsReducer>) {
        self.store = store
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
        
        store(.loadPosts(viewModels))
    }
}

extension ListPostsPresenter {
    
    func displayLatestPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        store(.loadError(viewModel))
    }
    
    func displayPopularPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        store(.loadError(viewModel))
    }
    
    func displayTopPickPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        store(.loadError(viewModel))
    }
    
    func displayPostsByTerms(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.postsByTermsErrorTitle),
            message: error.localizedDescription
        )
        
        store(.loadError(viewModel))
    }
}

extension ListPostsPresenter {
    
    func displayToggleFavorite(for response: ListPostsAPI.FavoriteResponse) {
        let viewModel = ListPostsAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        store(.toggleFavorite(viewModel))
    }
}
