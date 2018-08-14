//
//  HomeModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

enum HomeModels {
    
    struct FetchPostsRequest {
        let count: Int
    }
    
    struct FetchTermsRequest {
        let count: Int
    }
    
    struct PostsResponse {
        let posts: [PostType]
        let media: [MediaType]
    }
    
    struct TermsResponse {
        let terms: [TermType]
    }
}
