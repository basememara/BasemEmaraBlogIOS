//
//  TodayPresenter.swift
//  Today Extension
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftyPress
import UIKit.UIViewController
import ZamzamUI

struct TodayPresenter: TodayPresentable {
    private weak var viewController: (TodayDisplayable & UIViewController)?
    private let dateFormatter: DateFormatter
    
    init(viewController: (TodayDisplayable & UIViewController)?) {
        self.viewController = viewController
        
        self.dateFormatter = DateFormatter(
            dateFormat: "MMMM d yyyy"
        )
    }
}

extension TodayPresenter {
    
    func presentLatestPosts(for response: TodayAPI.Response) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.thumbnailLink,
                favorite: false, // TODO
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayLatestPosts(with: viewModels)
    }
    
    func presentLatestPosts(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.latestPostsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.present(
            alert: viewModel.title,
            message: viewModel.message
        )
    }
}
