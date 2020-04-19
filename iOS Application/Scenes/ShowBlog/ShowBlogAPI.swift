//
//  HomeInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamUI

protocol ShowBlogInteractorType: InteractorType {
    func fetchLatestPosts(with request: ShowBlogAPI.FetchPostsRequest)
    func fetchPopularPosts(with request: ShowBlogAPI.FetchPostsRequest)
    func fetchTopPickPosts(with request: ShowBlogAPI.FetchPostsRequest)
    func fetchTerms(with request: ShowBlogAPI.FetchTermsRequest)
    func toggleFavorite(with request: ShowBlogAPI.FavoriteRequest)
}

protocol ShowBlogPresenterType: PresenterType {
    func displayLatestPosts(for response: ShowBlogAPI.PostsResponse)
    func displayLatestPosts(error: DataError)
    
    func displayPopularPosts(for response: ShowBlogAPI.PostsResponse)
    func displayPopularPosts(error: DataError)
    
    func displayTopPickPosts(for response: ShowBlogAPI.PostsResponse)
    func displayTopPickPosts(error: DataError)
    
    func displayTerms(for response: ShowBlogAPI.TermsResponse)
    func displayTerms(error: DataError)
    
    func displayToggleFavorite(for response: ShowBlogAPI.FavoriteResponse)
}

protocol ShowBlogRenderType: RenderType {
    func listPosts(params: ListPostsAPI.Params)
    func showPost(for model: PostsDataViewModel)
    func showPost(for id: Int)
    func listTerms()
    func showDisclaimer(url: String?)
    func show(url: String?)
    func sendEmail(to email: String?)
}

// MARK: - Namespace

enum ShowBlogAPI {
    
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
