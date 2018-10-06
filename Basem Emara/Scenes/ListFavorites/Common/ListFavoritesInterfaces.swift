//
//  ListFavoritesInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol ListFavoritesBusinessLogic {
    func fetchFavoritePosts(with request: ListFavoritesModels.FetchPostsRequest)
}

protocol ListFavoritesPresentable {
    func presentFavoritePosts(for response: ListFavoritesModels.FetchPostsResponse)
    func presentFavoritePosts(error: DataError)
}

protocol ListFavoritesDisplayable: class, AppDisplayable {
    func displayPosts(with viewModels: [PostsDataViewModel])
}

protocol ListFavoritesRoutable: AppRoutable {
    func showPost(for model: PostsDataViewModel)
}
