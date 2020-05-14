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

struct ListFavoritesPresenter<Store: StoreRepresentable>: ListFavoritesPresenterType where Store.StateType == ListFavoritesState {
    private let store: Store
    private let dateFormatter: DateFormatter
    
    init(store: Store) {
        self.store = store
        self.dateFormatter = DateFormatter(dateStyle: .medium)
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
        
        store.action(.loadFavorites(viewModels))
    }
    
    func displayFavoritePosts(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        store.action(.loadError(viewModel))
    }
}

extension ListFavoritesPresenter {
    
    func displayToggleFavorite(for response: ListFavoritesAPI.FavoriteResponse) {
        let viewModel = ListFavoritesAPI.FavoriteViewModel(
            postID: response.postID,
            favorite: response.favorite
        )
        
        store.action(.toggleFavorite(viewModel))
    }
}
