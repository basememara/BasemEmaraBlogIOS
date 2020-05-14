//
//  ListPostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListPostsState: State {
    private(set) var posts: [PostsDataViewModel] = []
    private(set) var error: AppAPI.Error?
}

// MARK: - Reducer

extension ListPostsState {
    
    enum ListPostsAction: Action {
        case loadPosts([PostsDataViewModel])
        case toggleFavorite(ListPostsAPI.FavoriteViewModel)
        case loadError(AppAPI.Error?)
    }
    
    mutating func callAsFunction(_ action: ListPostsAction) {
        switch action {
        case .loadPosts(let value):
            posts = value
        case .toggleFavorite(let value):
            // TODO: Handle
            break
        case .loadError(let value):
            error = value
        }
    }
}
