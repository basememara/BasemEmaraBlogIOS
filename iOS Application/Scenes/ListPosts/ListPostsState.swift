//
//  ListPostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress

class ListPostsState: StateRepresentable {
    private let appState: AppState
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var posts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != posts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != posts else { return }
            notificationPost(for: \Self.posts)
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

extension ListPostsState {
    
    func subscribe(_ observer: @escaping (PartialKeyPath<ListPostsState>?) -> Void) {
        subscribe(observer, in: &cancellable)
        appState.subscribe(load, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

private extension ListPostsState {
    
    func load(_ keyPath: PartialKeyPath<AppState>?) {
        if keyPath == \AppState.allPosts || keyPath == nil {
            posts = posts.compactMap { post in appState.allPosts.first { $0.id == post.id } }
        }
    }
}

// MARK: - Action

enum ListPostsAction: Action {
    case loadPosts([PostsDataViewModel])
    case toggleFavorite(ListPostsAPI.FavoriteViewModel)
    case loadError(ViewError?)
}

// MARK: - Reducer

extension ListPostsState {
    
    func callAsFunction(_ action: ListPostsAction) {
        switch action {
        case .loadPosts(let items):
            posts = items
            appState(.mergePosts(items))
        case .toggleFavorite(let item):
            guard let current = appState.allPosts
                .first(where: { $0.id == item.postID })?
                .toggled(favorite: item.favorite) else {
                    return
            }
            
            appState(.mergePosts([current]))
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ListPostsState: ObservableObject {}
#endif
