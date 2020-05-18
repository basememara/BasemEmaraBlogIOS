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

protocol ShowPostInteractable: Interactor {
    func fetchPost(with request: ShowPostAPI.Request)
    func fetchByURL(with request: ShowPostAPI.FetchWebRequest)
    func toggleFavorite(with request: ShowPostAPI.FavoriteRequest)
}

protocol ShowPostPresentable: Presenter {
    func displayPost(for response: ShowPostAPI.Response)
    func displayPost(error: SwiftyPressError)
    
    func displayByURL(for response: ShowPostAPI.FetchWebResponse)
    
    func displayToggleFavorite(for response: ShowPostAPI.FavoriteResponse)
}

protocol ShowPostRenderable: Render {
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
        let post: Post
        let media: Media?
        let categories: [Term]
        let tags: [Term]
        let author: Author?
        let favorite: Bool
    }
    
    struct FetchWebResponse {
        let post: Post?
        let term: Term?
        let decisionHandler: ((WKNavigationActionPolicy) -> Void)
    }
    
    struct FavoriteResponse {
        let favorite: Bool
    }
    
    struct PostViewModel: Equatable {
        let title: String
        let link: String
        let content: String
        let commentCount: Int
        let favorite: Bool
    }
    
    struct PageViewModel: Equatable {
        let title: String
        let content: String
        let date: String
        let categories: [String]
        let tags: [String]
    }
    
    struct AuthorViewModel: Equatable {
        let name: String
        let content: String
        let avatar: String
    }
    
    struct WebViewModel: Equatable {
        let postID: Int?
        let termID: Int?
        let decisionHandler: ((WKNavigationActionPolicy) -> Void)
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.postID == rhs.postID
                && lhs.termID == rhs.termID
        }
    }
}
