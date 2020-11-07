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
    var model: TodayState
    private let dateFormatter = DateFormatter(dateFormat: "MMMM d yyyy")
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
        
        model.posts = viewModels
    }
    
    func displayLatestPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        model.error = viewModel
    }
}
