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
    private let dispatch: Dispatcher<ShowBlogAction>
    private let dateFormatter: DateFormatter
    
    init(dispatch: @escaping Dispatcher<ShowBlogAction>) {
        self.dispatch = dispatch
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
        
        dispatch(.loadLatestPosts(viewModels))
    }
    
    func displayLatestPosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        dispatch(.loadError(viewModel))
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
        
        dispatch(.loadPopularPosts(viewModels))
    }
    
    func displayPopularPosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        dispatch(.loadError(viewModel))
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
        
        dispatch(.loadTopPickPosts(viewModels))
    }
    
    func displayTopPickPosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        dispatch(.loadError(viewModel))
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
        
        dispatch(.loadTerms(viewModels))
    }
    
    func displayTerms(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        dispatch(.loadError(viewModel))
    }
}

extension ShowBlogPresenter {
    
    func displayToggleFavorite(for response: ShowBlogAPI.FavoriteResponse) {
        let viewModel = ShowBlogAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        dispatch(.toggleFavorite(viewModel))
    }
}
