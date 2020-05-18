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
    private let dispatch: Dispatcher<ListPostsAction>
    private let dateFormatter: DateFormatter
    
    init(dispatch: @escaping Dispatcher<ListPostsAction>) {
        self.dispatch = dispatch
        self.dateFormatter = DateFormatter(dateStyle: .medium)
    }
}

extension ListPostsPresenter {
    
    func displayPosts(for response: ListPostsAPI.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                dateFormatter: dateFormatter
            )
        }
        
        dispatch(.loadPosts(viewModels))
    }
}

extension ListPostsPresenter {
    
    func displayLatestPosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        dispatch(.loadError(viewModel))
    }
    
    func displayPopularPosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        dispatch(.loadError(viewModel))
    }
    
    func displayTopPickPosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        dispatch(.loadError(viewModel))
    }
    
    func displayPostsByTerms(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.postsByTermsErrorTitle),
            message: error.localizedDescription
        )
        
        dispatch(.loadError(viewModel))
    }
}

extension ListPostsPresenter {
    
    func displayToggleFavorite(for response: ListPostsAPI.FavoriteResponse) {
        let viewModel = ListPostsAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        dispatch(.toggleFavorite(viewModel))
    }
}
