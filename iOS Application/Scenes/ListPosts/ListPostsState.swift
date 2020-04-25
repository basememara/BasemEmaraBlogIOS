//
//  ListPostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListPostsState: StateType {
    private(set) var posts: [PostsDataViewModel] = []
    private(set) var error: AppAPI.Error?
}

// MARK: - Reducer

extension ListPostsState {
    
    enum Action: ActionType {
        case loadPosts([PostsDataViewModel])
        case toggleFavorite(ListPostsAPI.FavoriteViewModel)
        case loadError(AppAPI.Error?)
    }
    
    mutating func receive(_ action: Action) {
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
