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
    private let appState: AppState
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
    
    init(appState: AppState) {
        self.appState = appState
    }
}

extension ListFavoritesState {
    
    func subscribe(_ observer: @escaping (PartialKeyPath<ListFavoritesState>?) -> Void) {
        subscribe(observer, in: &cancellable)
        appState.subscribe(load, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

private extension ListFavoritesState {
    
    func load(_ keyPath: PartialKeyPath<AppState>?) {
        if keyPath == \AppState.allPosts || keyPath == nil {
            let sharedFavorites = appState.allPosts.filter { $0.favorite }
            
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
    case loadError(ViewError?)
}

// MARK: - Reducer

extension ListFavoritesState {
    
    func callAsFunction(_ action: ListFavoritesAction) {
        switch action {
        case .loadFavorites(let items):
            appState(.mergePosts(items))
        case .toggleFavorite(let item):
            appState(
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
