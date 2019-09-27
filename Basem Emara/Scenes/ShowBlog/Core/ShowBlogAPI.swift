//
//  HomeInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI

// Scene namespace
enum ShowBlogAPI {}

protocol ShowBlogModuleType {
    func component(with viewController: ShowBlogDisplayable?) -> ShowBlogActionable
    func component(with viewController: ShowBlogDisplayable?) -> ShowBlogPresentable
    func component(with viewController: UIViewController?) -> ShowBlogRoutable
    
    func component() -> MailComposerType
    func component() -> ConstantsType
    func component() -> Theme
}

protocol ShowBlogActionable: AppActionable {
    func fetchLatestPosts(with request: ShowBlogAPI.FetchPostsRequest)
    func fetchPopularPosts(with request: ShowBlogAPI.FetchPostsRequest)
    func fetchTopPickPosts(with request: ShowBlogAPI.FetchPostsRequest)
    func fetchTerms(with request: ShowBlogAPI.FetchTermsRequest)
    func toggleFavorite(with request: ShowBlogAPI.FavoriteRequest)
}

protocol ShowBlogPresentable: AppPresentable {
    func presentLatestPosts(for response: ShowBlogAPI.PostsResponse)
    func presentLatestPosts(error: DataError)
    
    func presentPopularPosts(for response: ShowBlogAPI.PostsResponse)
    func presentPopularPosts(error: DataError)
    
    func presentTopPickPosts(for response: ShowBlogAPI.PostsResponse)
    func presentTopPickPosts(error: DataError)
    
    func presentTerms(for response: ShowBlogAPI.TermsResponse)
    func presentTerms(error: DataError)
    
    func presentToggleFavorite(for response: ShowBlogAPI.FavoriteResponse)
}

protocol ShowBlogDisplayable: class, AppDisplayable {
    func displayLatestPosts(with viewModels: [PostsDataViewModel])
    func displayPopularPosts(with viewModels: [PostsDataViewModel])
    func displayTopPickPosts(with viewModels: [PostsDataViewModel])
    func displayTerms(with viewModels: [TermsDataViewModel])
    func displayToggleFavorite(with viewModel: ShowBlogAPI.FavoriteViewModel)
}

protocol ShowBlogRoutable: AppRoutable {
    func listPosts(params: ListPostsAPI.Params)
    func showPost(for model: PostsDataViewModel)
    func showPost(for id: Int)
    func listTerms()
}

extension ShowBlogAPI {
    
    struct FetchPostsRequest {
        let maxLength: Int
    }
    
    struct FetchTermsRequest {
        let maxLength: Int
    }
    
    struct FavoriteRequest {
        let postID: Int
    }
    
    struct PostsResponse {
        let posts: [PostType]
        let media: [MediaType]
        let favorites: [Int]
    }
    
    struct TermsResponse {
        let terms: [TermType]
    }
    
    struct FavoriteResponse {
        let postID: Int
        let favorite: Bool
    }
    
    struct FavoriteViewModel {
        let postID: Int
        let favorite: Bool
    }
}
