//
//  TodayInterfaces.swift
//  Today Extension
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol TodayInteractable: Interactor {
    func fetchLatestPosts(with request: TodayAPI.Request)
}

protocol TodayPresentable: Presenter {
    func displayLatestPosts(for response: TodayAPI.Response)
    func displayLatestPosts(error: SwiftyPressError)
}

// MARK: - Namespace

enum TodayAPI {
    
    struct Request {
        let maxLength: Int
    }
    
    struct Response {
        let posts: [Post]
        let media: [Media]
    }
}
