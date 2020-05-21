//
//  ShowBlogPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateFormatter
import SwiftyPress
import ZamzamUI

struct ShowBlogPresenter: ShowBlogPresentable {
    private let state: Reducer<ShowBlogAction>
    private let dateFormatter: DateFormatter
    
    init(state: @escaping Reducer<ShowBlogAction>) {
        self.state = state
        self.dateFormatter = DateFormatter(dateStyle: .medium)
    }
}

extension ShowBlogPresenter {
    
    func displayLatestPosts(for response: ShowBlogAPI.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                favorite: response.favorites.contains(post.id),
                dateFormatter: self.dateFormatter
            )
        }
        
        state(.loadLatestPosts(viewModels))
    }
    
    func displayLatestPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        state(.loadError(viewModel))
    }
}

extension ShowBlogPresenter {
    
    func displayPopularPosts(for response: ShowBlogAPI.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                favorite: response.favorites.contains(post.id),
                dateFormatter: self.dateFormatter
            )
        }
        
        state(.loadPopularPosts(viewModels))
    }
    
    func displayPopularPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        state(.loadError(viewModel))
    }
}

extension ShowBlogPresenter {
    
    func displayTopPickPosts(for response: ShowBlogAPI.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                favorite: response.favorites.contains(post.id),
                dateFormatter: self.dateFormatter
            )
        }
        
        state(.loadTopPickPosts(viewModels))
    }
    
    func displayTopPickPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        state(.loadError(viewModel))
    }
}

extension ShowBlogPresenter {
    
    func displayTerms(for response: ShowBlogAPI.TermsResponse) {
        let viewModels = response.terms.map {
            TermsDataViewModel(
                id: $0.id,
                name: $0.name,
                count: .localizedStringWithFormat("%d", $0.count),
                taxonomy: $0.taxonomy
            )
        }
        
        state(.loadTerms(viewModels))
    }
    
    func displayTerms(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        state(.loadError(viewModel))
    }
}

extension ShowBlogPresenter {
    
    func displayToggleFavorite(for response: ShowBlogAPI.FavoriteResponse) {
        let viewModel = ShowBlogAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        state(.toggleFavorite(viewModel))
    }
}
