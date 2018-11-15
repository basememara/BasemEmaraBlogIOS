//
//  TodayModels.swift
//  Today Extension
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

enum TodayModels {
    
    struct Request {
        let count: Int
    }
    
    struct Response {
        let posts: [PostType]
        let media: [MediaType]
    }
}
