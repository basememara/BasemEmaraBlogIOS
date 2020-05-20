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
    private let sharedState: SharedState
    private var postIDs: [Int] = []
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var posts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != posts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != posts else { return }
            notificationPost(keyPath: \ListPostsState.posts)
        }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet {
            guard newValue != error, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != error else { return }
            notificationPost(keyPath: \ListPostsState.error)
        }
    }
    
    // MARK: - Initializers
    
    init(sharedState: SharedState) {
        self.sharedState = sharedState
        self.sharedState.subscribe(load, in: &cancellable)
    }
}

private extension ListPostsState {
    
    func load(_ keyPath: PartialKeyPath<SharedState>?) {
        if keyPath == \SharedState.posts || keyPath == nil {
            posts = postIDs.compactMap { id in sharedState.posts.first { $0.id == id } }
        }
    }
}

// MARK: - Action

enum ListPostsAction: Action {
    case loadPosts([PostsDataViewModel])
    case toggleFavorite(ListPostsAPI.FavoriteViewModel)
    case loadError(AppAPI.Error?)
}

// MARK: - Reducer

extension ListPostsState {
    
    func reduce(_ action: ListPostsAction) {
        switch action {
        case .loadPosts(let items):
            postIDs = items.map(\.id)
            sharedState.reduce(.mergePosts(items))
        case .toggleFavorite(let item):
            guard let current = sharedState.posts
                .first(where: { $0.id == item.postID })?
                .toggled(favorite: item.favorite) else {
                    return
            }
            
            sharedState.reduce(.mergePosts([current]))
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - Conformances

extension ListPostsState: Equatable {
    
    static func == (lhs: ListPostsState, rhs: ListPostsState) -> Bool {
        lhs.posts == rhs.posts
            && lhs.error == rhs.error
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ListPostsState: ObservableObject {}
#endif
