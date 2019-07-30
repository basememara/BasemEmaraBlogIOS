//
//  TodayInterfaces.swift
//  Today Extension
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

protocol TodayBusinessLogic {
    func fetchLatestPosts(with request: TodayModels.Request)
}

protocol TodayPresentable {
    func presentLatestPosts(for response: TodayModels.Response)
    func presentLatestPosts(error: DataError)
}

protocol TodayDisplayable: class, AppDisplayable {
    func displayLatestPosts(with viewModels: [PostsDataViewModel])
}
