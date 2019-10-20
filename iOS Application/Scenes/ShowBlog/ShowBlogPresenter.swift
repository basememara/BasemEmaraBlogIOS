//
//  ShowBlogPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftyPress
import ZamzamUI

struct ShowBlogPresenter: ShowBlogPresentable {
    private weak var viewController: ShowBlogDisplayable?
    private let dateFormatter: DateFormatter
    
    init(viewController: ShowBlogDisplayable?) {
        self.viewController = viewController
        
        self.dateFormatter = DateFormatter().with {
            $0.dateStyle = .medium
            $0.timeStyle = .none
        }
    }
}

extension ShowBlogPresenter {
    
    func presentLatestPosts(for response: ShowBlogAPI.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                favorite: response.favorites.contains(post.id),
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayLatestPosts(with: viewModels)
    }
    
    func presentLatestPosts(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension ShowBlogPresenter {
    
    func presentPopularPosts(for response: ShowBlogAPI.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                favorite: response.favorites.contains(post.id),
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayPopularPosts(with: viewModels)
    }
    
    func presentPopularPosts(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension ShowBlogPresenter {
    
    func presentTopPickPosts(for response: ShowBlogAPI.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                favorite: response.favorites.contains(post.id),
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayTopPickPosts(with: viewModels)
    }
    
    func presentTopPickPosts(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension ShowBlogPresenter {
    
    func presentTerms(for response: ShowBlogAPI.TermsResponse) {
        let viewModels = response.terms.map {
            TermsDataViewModel(
                id: $0.id,
                name: $0.name,
                count: .localizedStringWithFormat("%d", $0.count),
                taxonomy: $0.taxonomy
            )
        }
        
        viewController?.displayTerms(with: viewModels)
    }
    
    func presentTerms(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension ShowBlogPresenter {
    
    func presentToggleFavorite(for response: ShowBlogAPI.FavoriteResponse) {
        viewController?.displayToggleFavorite(
            with: ShowBlogAPI.FavoriteViewModel(
                postID: response.postID,
                favorite: response.favorite
            )
        )
    }
}
