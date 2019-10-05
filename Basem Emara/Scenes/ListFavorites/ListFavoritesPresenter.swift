//
//  ListFavoritesPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftyPress
import ZamzamUI

struct ListFavoritesPresenter: ListFavoritesPresentable {
    private weak var viewController: ListFavoritesDisplayable?
    
    private let dateFormatter = DateFormatter().with {
        $0.dateStyle = .medium
        $0.timeStyle = .none
    }
    
    init(viewController: ListFavoritesDisplayable?) {
        self.viewController = viewController
    }
}

extension ListFavoritesPresenter {
    
    func presentFavoritePosts(for response: ListFavoritesAPI.FetchPostsResponse) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayPosts(with: viewModels)
    }
    
    func presentFavoritePosts(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension ListFavoritesPresenter {
    
    func presentToggleFavorite(for response: ListFavoritesAPI.FavoriteResponse) {
        viewController?.displayToggleFavorite(
            with: ListFavoritesAPI.FavoriteViewModel(
                postID: response.postID,
                favorite: response.favorite
            )
        )
    }
}
