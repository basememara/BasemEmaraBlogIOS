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

struct SearchPostsPresenter<Store: StoreRepresentable>: SearchPostsPresenterType where Store.StateType == SearchPostsState {
    private let store: Store
    private let dateFormatter: DateFormatter
    
    init(store: Store) {
        self.store = store
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
        
        store.send(.loadPosts(viewModels))
    }
    
    func displaySearchResults(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.searchErrorTitle),
            message: error.localizedDescription
        )
        
        store.send(.loadError(viewModel))
    }
}
