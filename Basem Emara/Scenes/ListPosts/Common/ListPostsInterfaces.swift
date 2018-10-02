//
//  ListPostsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol ListPostsBusinessLogic {
    func fetchLatestPosts(with request: ListPostsModels.FetchPostsRequest)
    func fetchPopularPosts(with request: ListPostsModels.FetchPostsRequest)
    func fetchTopPickPosts(with request: ListPostsModels.FetchPostsRequest)
    func fetchPostsByTerms(with request: ListPostsModels.FetchPostsByTermsRequest)
}

protocol ListPostsPresentable {
    func presentLatestPosts(for response: ListPostsModels.PostsResponse)
    func presentLatestPosts(error: DataError)
    
    func presentPopularPosts(for response: ListPostsModels.PostsResponse)
    func presentPopularPosts(error: DataError)
    
    func presentTopPickPosts(for response: ListPostsModels.PostsResponse)
    func presentTopPickPosts(error: DataError)
    
    func presentPostsByTerms(for response: ListPostsModels.PostsResponse)
    func presentPostsByTerms(error: DataError)
}

protocol ListPostsDisplayable: class, AppDisplayable {
    func displayPosts(with viewModels: [PostsDataViewModel])
}

protocol ListPostsRoutable: AppRoutable {
    func showPost(for model: PostsDataViewModel)
}
