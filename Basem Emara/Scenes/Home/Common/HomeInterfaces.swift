//
//  HomeInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

protocol HomeBusinessLogic {
    func fetchLatestPosts(with request: HomeModels.FetchPostsRequest)
    func fetchPopularPosts(with request: HomeModels.FetchPostsRequest)
    func fetchTopPickPosts(with request: HomeModels.FetchPostsRequest)
    func fetchTerms(with request: HomeModels.FetchTermsRequest)
    func toggleFavorite(with request: HomeModels.FavoriteRequest)
}

protocol HomePresentable {
    func presentLatestPosts(for response: HomeModels.PostsResponse)
    func presentLatestPosts(error: DataError)
    
    func presentPopularPosts(for response: HomeModels.PostsResponse)
    func presentPopularPosts(error: DataError)
    
    func presentTopPickPosts(for response: HomeModels.PostsResponse)
    func presentTopPickPosts(error: DataError)
    
    func presentTerms(for response: HomeModels.TermsResponse)
    func presentTerms(error: DataError)
    
    func presentToggleFavorite(for response: HomeModels.FavoriteResponse)
}

protocol HomeDisplayable: class, AppDisplayable {
    func displayLatestPosts(with viewModels: [PostsDataViewModel])
    func displayPopularPosts(with viewModels: [PostsDataViewModel])
    func displayTopPickPosts(with viewModels: [PostsDataViewModel])
    func displayTerms(with viewModels: [TermsDataViewModel])
    func displayToggleFavorite(with viewModel: HomeModels.FavoriteViewModel)
}

protocol HomeRoutable: AppRoutable {
    func listPosts(for fetchType: ListPostsViewController.FetchType)
    func showPost(for model: PostsDataViewModel)
    func showPost(for id: Int)
    func previewPost(for model: PostsDataViewModel) -> UIViewController?
    func listTerms()
}
