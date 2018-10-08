//
//  HomePresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct HomePresenter: HomePresentable {
    private weak var viewController: HomeDisplayable?
    
    private let dateFormatter = DateFormatter().with {
        $0.dateStyle = .medium
        $0.timeStyle = .none
    }
    
    init(viewController: HomeDisplayable?) {
        self.viewController = viewController
    }
}

extension HomePresenter {
    
    func presentLatestPosts(for response: HomeModels.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                media: response.media.first { $0.id == post.mediaID },
                favorite: response.favorites.contains(post.id),
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayLatestPosts(with: viewModels)
    }
    
    func presentLatestPosts(error: DataError) {
        let viewModel = AppModels.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension HomePresenter {
    
    func presentPopularPosts(for response: HomeModels.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                media: response.media.first { $0.id == post.mediaID },
                favorite: response.favorites.contains(post.id),
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayPopularPosts(with: viewModels)
    }
    
    func presentPopularPosts(error: DataError) {
        let viewModel = AppModels.Error(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension HomePresenter {
    
    func presentTopPickPosts(for response: HomeModels.PostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                media: response.media.first { $0.id == post.mediaID },
                favorite: response.favorites.contains(post.id),
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayTopPickPosts(with: viewModels)
    }
    
    func presentTopPickPosts(error: DataError) {
        let viewModel = AppModels.Error(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension HomePresenter {
    
    func presentTerms(for response: HomeModels.TermsResponse) {
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
        let viewModel = AppModels.Error(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}
