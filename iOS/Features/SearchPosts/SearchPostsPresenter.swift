//
//  SearchPostsPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI

struct SearchPostsPresenter: SearchPostsPresentable {
    var model: SearchPostsModel
    private let dateFormatter = DateFormatter(dateStyle: .medium)
}

extension SearchPostsPresenter {

    func displaySearchResults(for response: SearchPostsAPI.Response) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                favorite: response.favoriteIDs.contains(post.id),
                dateFormatter: self.dateFormatter
            )
        }
        
        model(\.posts, viewModels)
    }
    
    func displaySearchResults(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.searchErrorTitle),
            message: error.localizedDescription
        )
        
        model(\.error, viewModel)
    }
}
