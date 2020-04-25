//
//  ListFavoritesState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-22.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListFavoritesState: StateType {
    private(set) var favorites: [PostsDataViewModel] = []
    private(set) var error: AppAPI.Error?
}

// MARK: - Reducer

extension ListFavoritesState {
    
    enum Action: ActionType {
        case loadFavorites([PostsDataViewModel])
        case toggleFavorite(ListFavoritesAPI.FavoriteViewModel)
        case loadError(AppAPI.Error?)
    }
    
    mutating func receive(_ action: Action) {
        switch action {
        case .loadFavorites(let value):
            favorites = value
        case .toggleFavorite(let value):
            guard value.favorite else {
                if let index = favorites
                    .firstIndex(where: { $0.id == value.postID }) {
                    favorites.remove(at: index)
                }
                
                return
            }
            
            // TODO: Add favorite item
        case .loadError(let value):
            error = value
        }
    }
}
