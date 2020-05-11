//
//  SearchPostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct SearchPostsState: State {
    private(set) var posts: [PostsDataViewModel] = []
    private(set) var error: AppAPI.Error?
}

// MARK: - Reducer

extension SearchPostsState {
    
    enum SearchPostsAction: Action {
        case loadPosts([PostsDataViewModel])
        case loadError(AppAPI.Error?)
    }
    
    mutating func receive(_ action: SearchPostsAction) {
        switch action {
        case .loadPosts(let value):
            posts = value
        case .loadError(let value):
            error = value
        }
    }
}
