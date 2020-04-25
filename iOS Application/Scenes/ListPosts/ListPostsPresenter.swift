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

struct ListPostsPresenter: ListPostsPresenterType {
    private let send: SendAction<ListPostsState>
    private let dateFormatter: DateFormatter
    
    init(send: @escaping SendAction<ListPostsState>) {
        self.send = send
        
        self.dateFormatter = DateFormatter().with {
            $0.dateStyle = .medium
            $0.timeStyle = .none
        }
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
        
        send(.loadPosts(viewModels))
    }
}

extension ListPostsPresenter {
    
    func displayLatestPosts(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
    }
    
    func displayPopularPosts(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.popularPostsErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
    }
    
    func displayTopPickPosts(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.topPickPostsErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
    }
    
    func displayPostsByTerms(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.postsByTermsErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
    }
}

extension ListPostsPresenter {
    
    func displayToggleFavorite(for response: ListPostsAPI.FavoriteResponse) {
        let viewModel = ListPostsAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        send(.toggleFavorite(viewModel))
    }
}
