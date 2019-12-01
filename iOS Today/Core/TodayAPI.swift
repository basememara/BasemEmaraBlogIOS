//
//  TodayInterfaces.swift
//  Today Extension
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamUI

// Scene namespace
enum TodayAPI {}

protocol TodayModuleType {
    func component(with viewController: TodayDisplayable?) -> TodayActionable
    func component(with viewController: TodayDisplayable?) -> TodayPresentable
    func component() -> DataProviderType
    func component() -> Theme
}

protocol TodayActionable {
    func fetchLatestPosts(with request: TodayAPI.Request)
}

protocol TodayPresentable {
    func presentLatestPosts(for response: TodayAPI.Response)
    func presentLatestPosts(error: DataError)
}

protocol TodayDisplayable: class, AppDisplayable {
    func displayLatestPosts(with viewModels: [PostsDataViewModel])
}

extension TodayAPI {
    
    struct Request {
        let maxLength: Int
    }
    
    struct Response {
        let posts: [PostType]
        let media: [MediaType]
    }
}
