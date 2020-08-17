//
//  TodayPresenter.swift
//  Today Extension
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSDateFormatter
import SwiftyPress
import ZamzamUI

struct TodayPresenter: TodayPresentable {
    private let state: StateReducer<TodayReducer>
    private let dateFormatter: DateFormatter
    
    init(state: @escaping StateReducer<TodayReducer>) {
        self.state = state
        self.dateFormatter = DateFormatter(dateFormat: "MMMM d yyyy")
    }
}

extension TodayPresenter {
    
    func displayLatestPosts(for response: TodayAPI.Response) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.thumbnailLink,
                favorite: false,
                dateFormatter: self.dateFormatter
            )
        }
        
        state(.loadPosts(viewModels))
    }
    
    func displayLatestPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        state(.loadError(viewModel))
    }
}
