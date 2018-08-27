//
//  HomeInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol HomeBusinessLogic {
    func fetchLatestPosts(with request: HomeModels.FetchPostsRequest)
    func fetchPopularPosts(with request: HomeModels.FetchPostsRequest)
    func fetchTopPickPosts(with request: HomeModels.FetchPostsRequest)
    func fetchTerms(with request: HomeModels.FetchTermsRequest)
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
}

protocol HomeDisplayable: class, AppDisplayable {
    func displayLatestPosts(with viewModels: [PostsDataViewModel])
    func displayPopularPosts(with viewModels: [PostsDataViewModel])
    func displayTopPickPosts(with viewModels: [PostsDataViewModel])
    func displayTerms(with viewModels: [TermsDataViewModel])
}

protocol HomeRoutable {
    func listPosts(for fetchType: ListPostsViewController.FetchType)
}
