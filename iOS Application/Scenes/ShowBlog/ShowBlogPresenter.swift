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

struct ShowBlogPresenter<Store: StoreType>: ShowBlogPresenterType where Store.State == ShowBlogState {
    private let store: Store
    private let dateFormatter: DateFormatter
    
    init(store: Store) {
        self.store = store
        
        self.dateFormatter = DateFormatter().apply {
            $0.dateStyle = .medium
            $0.timeStyle = .none
        }
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
        
        store.send(.loadLatestPosts(viewModels))
    }
    
    func displayLatestPosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        store.send(.loadError(viewModel))
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
        
        store.send(.loadPopularPosts(viewModels))
    }
    
    func displayPopularPosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        store.send(.loadError(viewModel))
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
        
        store.send(.loadTopPickPosts(viewModels))
    }
    
    func displayTopPickPosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        store.send(.loadError(viewModel))
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
        
        store.send(.loadTerms(viewModels))
    }
    
    func displayTerms(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        store.send(.loadError(viewModel))
    }
}

extension ShowBlogPresenter {
    
    func displayToggleFavorite(for response: ShowBlogAPI.FavoriteResponse) {
        let viewModel = ShowBlogAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        store.send(.toggleFavorite(viewModel))
    }
}
