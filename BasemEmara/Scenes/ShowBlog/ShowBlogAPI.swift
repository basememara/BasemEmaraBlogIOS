//
//  HomeInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamUI

protocol ShowBlogInteractable: Interactor {
    func fetchLatestPosts(with request: ShowBlogAPI.FetchPostsRequest)
    func fetchPopularPosts(with request: ShowBlogAPI.FetchPostsRequest)
    func fetchTopPickPosts(with request: ShowBlogAPI.FetchPostsRequest)
    func fetchTerms(with request: ShowBlogAPI.FetchTermsRequest)
    func toggleFavorite(with request: ShowBlogAPI.FavoriteRequest)
}

protocol ShowBlogPresentable: Presenter {
    func displayLatestPosts(for response: ShowBlogAPI.PostsResponse)
    func displayLatestPosts(error: SwiftyPressError)
    
    func displayPopularPosts(for response: ShowBlogAPI.PostsResponse)
    func displayPopularPosts(error: SwiftyPressError)
    
    func displayTopPickPosts(for response: ShowBlogAPI.PostsResponse)
    func displayTopPickPosts(error: SwiftyPressError)
    
    func displayTerms(for response: ShowBlogAPI.TermsResponse)
    func displayTerms(error: SwiftyPressError)
    
    func displayToggleFavorite(for response: ShowBlogAPI.FavoriteResponse)
}

protocol ShowBlogRenderable: Render {
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
        let posts: [Post]
        let media: [Media]
        let favorites: [Int]
    }
    
    struct TermsResponse {
        let terms: [Term]
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
