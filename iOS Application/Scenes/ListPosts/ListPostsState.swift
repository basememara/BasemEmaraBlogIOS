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
    private let parent: AppState
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
    
    init(parent: AppState) {
        self.parent = parent
    }
}

extension ListPostsState {
    
    func subscribe(_ observer: @escaping (StateChange<ListPostsState>) -> Void) {
        subscribe(observer, in: &cancellable)
        parent.subscribe(load, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

private extension ListPostsState {
    
    func load(_ result: StateChange<AppState>) {
        guard result == .updated(\AppState.allPosts) || result == .initial else { return }
        posts = posts.compactMap { post in parent.allPosts.first { $0.id == post.id } }
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
            parent(.mergePosts(items))
        case .toggleFavorite(let item):
            guard let current = parent.allPosts
                .first(where: { $0.id == item.postID })?
                .toggled(favorite: item.favorite) else {
                    return
            }
            
            parent(.mergePosts([current]))
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
