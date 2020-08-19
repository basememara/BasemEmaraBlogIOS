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
    private let postsState: PostsState
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    fileprivate(set) var favorites: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != favorites, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != favorites else { return }
            notificationPost(for: \Self.favorites)
        }
    }
    
    fileprivate(set) var error: ViewError? {
        willSet {
            guard newValue != error, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != error else { return }
            notificationPost(for: \Self.error)
        }
    }
    
    init(postsState: PostsState) {
        self.postsState = postsState
    }
}

extension ListFavoritesState {
    
    func subscribe(_ observer: @escaping (StateChange<ListFavoritesState>) -> Void) {
        subscribe(observer, in: &cancellable)
        postsState.subscribe(postsLoad, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

private extension ListFavoritesState {
    
    func postsLoad(_ result: StateChange<PostsState>) {
        guard result == .updated(\PostsState.allPosts) || result == .initial else { return }
        
        var sharedFavorites = postsState.allPosts.filter { $0.value.favorite }
        let sorted = favorites.compactMap { sharedFavorites.removeValue(forKey: $0.id) }
        favorites = sorted + sharedFavorites.values
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ListFavoritesState: ObservableObject {}
#endif

// MARK: - Reducer

enum ListFavoritesReducer: Reducer {
    case loadFavorites([PostsDataViewModel])
    case toggleFavorite(ListFavoritesAPI.FavoriteViewModel)
    case loadError(ViewError)
}

extension AppStore {
    
    func reduce(_ reducer: ListFavoritesReducer) {
        switch reducer {
        case .loadFavorites(let items):
            reduce(.mergePosts(items))
        case .toggleFavorite(let item):
            reduce(
                .toggleFavorite(
                    postID: item.postID,
                    favorite: item.favorite
                )
            )
        case .loadError(let item):
            listFavoritesState.error = item
        }
    }
}
