//
//  ListFavoritesState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-22.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress

class ListFavoritesState: StateRepresentable {
    private let sharedState: SharedState
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var favorites: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != favorites, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != favorites else { return }
            notificationPost(keyPath: \ListFavoritesState.favorites)
        }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet {
            guard newValue != error, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != error else { return }
            notificationPost(keyPath: \ListFavoritesState.error)
        }
    }
    
    // MARK: - Initializers
    
    init(sharedState: SharedState) {
        self.sharedState = sharedState
        self.sharedState.subscribe(load, in: &cancellable)
    }
}

private extension ListFavoritesState {
    
    func load(_ keyPath: PartialKeyPath<SharedState>?) {
        if keyPath == \SharedState.posts || keyPath == nil {
            let sharedFavorites = sharedState.posts.filter { $0.favorite }
            
            let sorted = favorites
                .compactMap { item in sharedFavorites.first { $0.id == item.id } }
            
            favorites = sorted + sharedFavorites.filter { !sorted.contains($0) }
        }
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
    
    func callAsFunction(_ action: ListFavoritesAction) {
        switch action {
        case .loadFavorites(let items):
            sharedState(.mergePosts(items))
        case .toggleFavorite(let item):
            sharedState(
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
