//
//  HomeInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

protocol ShowDashboardBusinessLogic: AppBusinessLogic {
    func fetchLatestPosts(with request: ShowDashboardModels.FetchPostsRequest)
    func fetchPopularPosts(with request: ShowDashboardModels.FetchPostsRequest)
    func fetchTopPickPosts(with request: ShowDashboardModels.FetchPostsRequest)
    func fetchTerms(with request: ShowDashboardModels.FetchTermsRequest)
    func toggleFavorite(with request: ShowDashboardModels.FavoriteRequest)
}

protocol ShowDashboardPresentable: AppPresentable {
    func presentLatestPosts(for response: ShowDashboardModels.PostsResponse)
    func presentLatestPosts(error: DataError)
    
    func presentPopularPosts(for response: ShowDashboardModels.PostsResponse)
    func presentPopularPosts(error: DataError)
    
    func presentTopPickPosts(for response: ShowDashboardModels.PostsResponse)
    func presentTopPickPosts(error: DataError)
    
    func presentTerms(for response: ShowDashboardModels.TermsResponse)
    func presentTerms(error: DataError)
    
    func presentToggleFavorite(for response: ShowDashboardModels.FavoriteResponse)
}

protocol ShowDashboardDisplayable: class, AppDisplayable {
    func displayLatestPosts(with viewModels: [PostsDataViewModel])
    func displayPopularPosts(with viewModels: [PostsDataViewModel])
    func displayTopPickPosts(with viewModels: [PostsDataViewModel])
    func displayTerms(with viewModels: [TermsDataViewModel])
    func displayToggleFavorite(with viewModel: ShowDashboardModels.FavoriteViewModel)
}

protocol ShowDashboardRoutable: AppRoutable {
    func listPosts(for fetchType: ListPostsViewController.FetchType)
    func showPost(for model: PostsDataViewModel)
    func showPost(for id: Int)
    func previewPost(for model: PostsDataViewModel) -> UIViewController?
    func listTerms()
}
