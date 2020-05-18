//
//  ListPostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

class ListPostsState: StateRepresentable {
    
    private(set) var posts: [PostsDataViewModel] = [] {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ListPostsState.posts) }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ListPostsState.error) }
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
        case .loadPosts(let item):
            posts = item
        case .toggleFavorite(let item):
            // TODO: Handle
            break
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
