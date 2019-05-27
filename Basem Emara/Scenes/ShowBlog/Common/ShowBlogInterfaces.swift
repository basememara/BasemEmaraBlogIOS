//
//  HomeInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

protocol ShowBlogBusinessLogic: AppBusinessLogic {
    func fetchLatestPosts(with request: ShowBlogModels.FetchPostsRequest)
    func fetchPopularPosts(with request: ShowBlogModels.FetchPostsRequest)
    func fetchTopPickPosts(with request: ShowBlogModels.FetchPostsRequest)
    func fetchTerms(with request: ShowBlogModels.FetchTermsRequest)
    func toggleFavorite(with request: ShowBlogModels.FavoriteRequest)
}

protocol ShowBlogPresentable: AppPresentable {
    func presentLatestPosts(for response: ShowBlogModels.PostsResponse)
    func presentLatestPosts(error: DataError)
    
    func presentPopularPosts(for response: ShowBlogModels.PostsResponse)
    func presentPopularPosts(error: DataError)
    
    func presentTopPickPosts(for response: ShowBlogModels.PostsResponse)
    func presentTopPickPosts(error: DataError)
    
    func presentTerms(for response: ShowBlogModels.TermsResponse)
    func presentTerms(error: DataError)
    
    func presentToggleFavorite(for response: ShowBlogModels.FavoriteResponse)
}

protocol ShowBlogDisplayable: class, AppDisplayable {
    func displayLatestPosts(with viewModels: [PostsDataViewModel])
    func displayPopularPosts(with viewModels: [PostsDataViewModel])
    func displayTopPickPosts(with viewModels: [PostsDataViewModel])
    func displayTerms(with viewModels: [TermsDataViewModel])
    func displayToggleFavorite(with viewModel: ShowBlogModels.FavoriteViewModel)
}

protocol ShowBlogRoutable: AppRoutable {
    func listPosts(params: ListPostsModels.Params)
    func showPost(for model: PostsDataViewModel)
    func showPost(for id: Int)
    func previewPost(for model: PostsDataViewModel) -> UIViewController?
    func listTerms()
}
