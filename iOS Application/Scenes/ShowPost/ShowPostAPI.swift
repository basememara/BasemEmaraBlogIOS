//
//  ShowPostInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import WebKit
import ZamzamUI

protocol ShowPostInteractorType: InteractorType {
    func fetchPost(with request: ShowPostAPI.Request)
    func fetchByURL(with request: ShowPostAPI.FetchWebRequest)
    func toggleFavorite(with request: ShowPostAPI.FavoriteRequest)
}

protocol ShowPostPresenterType: PresenterType {
    func displayPost(for response: ShowPostAPI.Response)
    func displayPost(error: DataError)
    
    func displayByURL(for response: ShowPostAPI.FetchWebResponse)
    
    func displayToggleFavorite(for response: ShowPostAPI.FavoriteResponse)
}

protocol ShowPostRenderType: RenderType {
    func listPosts(params: ListPostsAPI.Params)
    func show(url: String)
}

protocol ShowPostLoadable {
    func load(_ id: Int)
}

// MARK: - Namespace

enum ShowPostAPI {
    
    struct Request {
        let postID: Int
    }
    
    struct FetchWebRequest {
        let url: String
        let decisionHandler: ((WKNavigationActionPolicy) -> Void)
    }
    
    struct FavoriteRequest {
        let postID: Int
    }
    
    struct Response {
        let post: PostType
        let media: MediaType?
        let categories: [TermType]
        let tags: [TermType]
        let author: AuthorType?
        let favorite: Bool
    }
    
    struct FetchWebResponse {
        let post: PostType?
        let term: TermType?
        let decisionHandler: ((WKNavigationActionPolicy) -> Void)
    }
    
    struct FavoriteResponse {
        let favorite: Bool
    }
    
    struct PostViewModel {
        let title: String
        let link: String
        let content: String
        let commentCount: Int
        let favorite: Bool
    }
    
    struct PageViewModel {
        let title: String
        let content: String
        let date: String
        let categories: [String]
        let tags: [String]
    }
    
    struct AuthorViewModel {
        let name: String
        let content: String
        let avatar: String
    }
    
    struct WebViewModel {
        let postID: Int?
        let termID: Int?
        let decisionHandler: ((WKNavigationActionPolicy) -> Void)
    }
}
