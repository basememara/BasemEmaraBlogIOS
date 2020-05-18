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
    private let dispatch: Dispatcher<SearchPostsAction>
    private let dateFormatter: DateFormatter
    
    init(dispatch: @escaping Dispatcher<SearchPostsAction>) {
        self.dispatch = dispatch
        self.dateFormatter = DateFormatter(dateStyle: .medium)
    }
}

extension SearchPostsPresenter {

    func displaySearchResults(for response: SearchPostsAPI.Response) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                mediaURL: response.media.first { $0.id == post.mediaID }?.link,
                dateFormatter: self.dateFormatter
            )
        }
        
        dispatch(.loadPosts(viewModels))
    }
    
    func displaySearchResults(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.searchErrorTitle),
            message: error.localizedDescription
        )
        
        dispatch(.loadError(viewModel))
    }
}
