//
//  ShowBlogModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

enum ShowBlogModels {
    
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
