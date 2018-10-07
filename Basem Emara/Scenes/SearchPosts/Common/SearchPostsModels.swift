//
//  SearchPostsModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

enum SearchPostsModels {
    
    struct Response {
        let posts: [PostType]
        let media: [MediaType]
    }
}
