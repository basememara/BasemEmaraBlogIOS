//
//  ListFavoritesPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateFormatter
import SwiftyPress
import ZamzamUI

struct ListFavoritesPresenter: ListFavoritesPresenterType {
    private let send: SendAction<ListFavoritesState>
    private let dateFormatter: DateFormatter
    
    init(send: @escaping SendAction<ListFavoritesState>) {
        self.send = send
        
        self.dateFormatter = DateFormatter().apply {
            $0.dateStyle = .medium
            $0.timeStyle = .none
        }
    }
}

extension ListFavoritesPresenter {
    
    func displayFavoritePosts(for response: ListFavoritesAPI.FetchPostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                dateFormatter: dateFormatter
            )
        }
        
        send(.loadFavorites(viewModels))
    }
    
    func displayFavoritePosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
    }
}

extension ListFavoritesPresenter {
    
    func displayToggleFavorite(for response: ListFavoritesAPI.FavoriteResponse) {
        let viewModel = ListFavoritesAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        send(.toggleFavorite(viewModel))
    }
}
