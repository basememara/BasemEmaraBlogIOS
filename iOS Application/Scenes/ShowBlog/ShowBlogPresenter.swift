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

struct ShowBlogPresenter: ShowBlogPresenterType {
    private let send: SendAction<ShowBlogState>
    private let dateFormatter: DateFormatter
    
    init(send: @escaping SendAction<ShowBlogState>) {
        self.send = send
        
        self.dateFormatter = DateFormatter().with {
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
        
        send(.loadLatestPosts(viewModels))
    }
    
    func displayLatestPosts(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
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
        
        send(.loadPopularPosts(viewModels))
    }
    
    func displayPopularPosts(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
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
        
        send(.loadTopPickPosts(viewModels))
    }
    
    func displayTopPickPosts(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
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
        
        send(.loadTerms(viewModels))
    }
    
    func displayTerms(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
    }
}

extension ShowBlogPresenter {
    
    func displayToggleFavorite(for response: ShowBlogAPI.FavoriteResponse) {
        let viewModel = ShowBlogAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        send(.toggleFavorite(viewModel))
    }
}
