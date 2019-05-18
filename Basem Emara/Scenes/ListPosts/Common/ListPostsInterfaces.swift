//
//  ListPostsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

protocol ListPostsBusinessLogic: AppBusinessLogic {
    func fetchLatestPosts(with request: ListPostsModels.FetchPostsRequest)
    func fetchPopularPosts(with request: ListPostsModels.FetchPostsRequest)
    func fetchTopPickPosts(with request: ListPostsModels.FetchPostsRequest)
    func fetchPostsByTerms(with request: ListPostsModels.FetchPostsByTermsRequest)
    func toggleFavorite(with request: ListPostsModels.FavoriteRequest)
    func isFavorite(postID: Int) -> Bool
}

protocol ListPostsPresentable: AppPresentable {
    func presentLatestPosts(for response: ListPostsModels.PostsResponse)
    func presentLatestPosts(error: DataError)
    
    func presentPopularPosts(for response: ListPostsModels.PostsResponse)
    func presentPopularPosts(error: DataError)
    
    func presentTopPickPosts(for response: ListPostsModels.PostsResponse)
    func presentTopPickPosts(error: DataError)
    
    func presentPostsByTerms(for response: ListPostsModels.PostsResponse)
    func presentPostsByTerms(error: DataError)
    
    func presentToggleFavorite(for response: ListPostsModels.FavoriteResponse)
}

protocol ListPostsDisplayable: class, AppDisplayable {
    func displayPosts(with viewModels: [PostsDataViewModel])
    func displayToggleFavorite(with viewModel: ListPostsModels.FavoriteViewModel)
}

protocol ListPostsRoutable: AppRoutable {
    func showPost(for model: PostsDataViewModel)
    func previewPost(for model: PostsDataViewModel) -> UIViewController?
}
