//
//  ListPostsPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListPostsPresenter: ListPostsPresentable {
    private weak var viewController: ListPostsDisplayable?
    
    private let dateFormatter = DateFormatter().with {
        $0.dateStyle = .medium
        $0.timeStyle = .none
    }
    
    init(viewController: ListPostsDisplayable?) {
        self.viewController = viewController
    }
}

extension ListPostsPresenter {
    
    func presentLatestPosts(for response: ListPostsModels.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                media: response.media.first { $0.id == post.mediaID },
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayPosts(with: viewModels)
    }
    
    func presentLatestPosts(error: DataError) {
        let viewModel = AppModels.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension ListPostsPresenter {
    
    func presentPopularPosts(for response: ListPostsModels.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                media: response.media.first { $0.id == post.mediaID },
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayPosts(with: viewModels)
    }
    
    func presentPopularPosts(error: DataError) {
        let viewModel = AppModels.Error(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension ListPostsPresenter {
    
    func presentTopPickPosts(for response: ListPostsModels.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                media: response.media.first { $0.id == post.mediaID },
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayPosts(with: viewModels)
    }
    
    func presentTopPickPosts(error: DataError) {
        let viewModel = AppModels.Error(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension ListPostsPresenter {
    
    func presentPostsByTerms(for response: ListPostsModels.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                media: response.media.first { $0.id == post.mediaID },
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayPosts(with: viewModels)
    }
    
    func presentPostsByTerms(error: DataError) {
        let viewModel = AppModels.Error(
            title: .localized(.postsByTermsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension ListPostsPresenter {
    
    func presentToggleFavorite(for response: ListPostsModels.FavoriteResponse) {
        viewController?.displayToggleFavorite(
            with: ListPostsModels.FavoriteViewModel(
                postID: response.postID,
                favorite: response.favorite
            )
        )
    }
}
