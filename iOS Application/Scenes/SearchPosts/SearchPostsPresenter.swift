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

struct SearchPostsPresenter: SearchPostsPresenterType {
    private let send: SendAction<SearchPostsState>
    private let dateFormatter: DateFormatter
    
    init(send: @escaping SendAction<SearchPostsState>) {
        self.send = send
        
        dateFormatter = DateFormatter().with {
            $0.dateStyle = .medium
            $0.timeStyle = .none
        }
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
        
        send(.loadPosts(viewModels))
    }
    
    func displaySearchResults(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.searchErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
    }
}
