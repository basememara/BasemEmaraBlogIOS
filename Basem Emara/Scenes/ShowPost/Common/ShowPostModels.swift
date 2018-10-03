//
//  ShowPostModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import WebKit
import SwiftyPress

enum ShowPostModels {
    
    struct Request {
        let postID: Int
    }
    
    struct FetchWebRequest {
        let url: String
        let decisionHandler: ((WKNavigationActionPolicy) -> Void)
    }
    
    struct Response {
        let post: PostType
        let media: MediaType?
        let categories: [TermType]
        let tags: [TermType]
        let author: AuthorType?
    }
    
    struct FetchWebResponse {
        let post: PostType?
        let term: TermType?
        let decisionHandler: ((WKNavigationActionPolicy) -> Void)
    }
    
    struct ViewModel {
        let title: String
        let content: String
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
