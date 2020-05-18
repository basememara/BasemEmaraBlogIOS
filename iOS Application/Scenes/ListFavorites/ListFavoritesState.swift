//
//  ListFavoritesState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-22.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

class ListFavoritesState: StateRepresentable {
    
    private(set) var favorites: [PostsDataViewModel] = [] {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ListFavoritesState.favorites) }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ListFavoritesState.error) }
    }
}

// MARK: - Action

enum ListFavoritesAction: Action {
    case loadFavorites([PostsDataViewModel])
    case toggleFavorite(ListFavoritesAPI.FavoriteViewModel)
    case loadError(AppAPI.Error?)
}

// MARK: - Reducer

extension ListFavoritesState {
    
    func reduce(_ action: ListFavoritesAction) {
        switch action {
        case .loadFavorites(let item):
            favorites = item
        case .toggleFavorite(let item):
            guard item.favorite else {
                if let index = favorites
                    .firstIndex(where: { $0.id == item.postID }) {
                    favorites.remove(at: index)
                }
                
                return
            }
            
            // TODO: Add favorite item
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - Conformances

extension ListFavoritesState: Equatable {
    
    static func == (lhs: ListFavoritesState, rhs: ListFavoritesState) -> Bool {
        lhs.favorites == rhs.favorites
            && lhs.error == rhs.error
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ListFavoritesState: ObservableObject {}
#endif
