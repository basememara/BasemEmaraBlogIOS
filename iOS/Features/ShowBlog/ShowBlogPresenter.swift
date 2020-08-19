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
    private let store: StoreReducer<ShowBlogReducer>
    private let dateFormatter: DateFormatter
    
    init(_ store: @escaping StoreReducer<ShowBlogReducer>) {
        self.store = store
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
        
        store(.loadLatestPosts(viewModels))
    }
    
    func displayLatestPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        store(.loadError(viewModel))
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
        
        store(.loadPopularPosts(viewModels))
    }
    
    func displayPopularPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        store(.loadError(viewModel))
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
        
        store(.loadTopPickPosts(viewModels))
    }
    
    func displayTopPickPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        store(.loadError(viewModel))
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
        
        store(.loadTerms(viewModels))
    }
    
    func displayTerms(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        store(.loadError(viewModel))
    }
}

extension ShowBlogPresenter {
    
    func displayToggleFavorite(for response: ShowBlogAPI.FavoriteResponse) {
        let viewModel = ShowBlogAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        store(.toggleFavorite(viewModel))
    }
}
