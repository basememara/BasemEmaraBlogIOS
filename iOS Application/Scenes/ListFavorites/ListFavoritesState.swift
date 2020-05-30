//
//  ListFavoritesState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-22.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress
import ZamzamUI

class ListFavoritesState: StateRepresentable {
    private let parent: AppState
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var favorites: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != favorites, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != favorites else { return }
            notificationPost(for: \Self.favorites)
        }
    }
    
    private(set) var error: ViewError? {
        willSet {
            guard newValue != error, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != error else { return }
            notificationPost(for: \Self.error)
        }
    }
    
    init(parent: AppState) {
        self.parent = parent
    }
}

extension ListFavoritesState {
    
    func subscribe(_ observer: @escaping (StateChange<ListFavoritesState>) -> Void) {
        subscribe(observer, in: &cancellable)
        parent.subscribe(load, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

private extension ListFavoritesState {
    
    func load(_ result: StateChange<AppState>) {
        guard result == .updated(\AppState.allPosts) || result == .initial else { return }
        
        let sharedFavorites = parent.allPosts.filter { $0.favorite }
        let sorted = favorites.compactMap { item in sharedFavorites.first { $0.id == item.id } }
        favorites = sorted + sharedFavorites.filter { !sorted.contains($0) }
    }
}

// MARK: - Action

enum ListFavoritesAction: Action {
    case loadFavorites([PostsDataViewModel])
    case toggleFavorite(ListFavoritesAPI.FavoriteViewModel)
    case loadError(ViewError)
}

// MARK: - Reducer

extension ListFavoritesState {
    
    func callAsFunction(_ action: ListFavoritesAction) {
        switch action {
        case .loadFavorites(let items):
            parent(.mergePosts(items))
        case .toggleFavorite(let item):
            parent(
                .toggleFavorite(
                    postID: item.postID,
                    favorite: item.favorite
                )
            )
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ListFavoritesState: ObservableObject {}
#endif
