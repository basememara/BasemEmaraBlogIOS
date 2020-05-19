//
//  SearchPostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

class SearchPostsState: StateRepresentable {
    
    private(set) var posts: [PostsDataViewModel] = [] {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \SearchPostsState.posts) }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \SearchPostsState.error) }
    }
}

// MARK: - Action

enum SearchPostsAction: Action {
    case loadPosts([PostsDataViewModel])
    case loadError(AppAPI.Error?)
}

// MARK: - Reducer

extension SearchPostsState {
    
    func reduce(_ action: SearchPostsAction) {
        switch action {
        case .loadPosts(let items):
            posts = items
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - Conformances

extension SearchPostsState: Equatable {
    
    static func == (lhs: SearchPostsState, rhs: SearchPostsState) -> Bool {
        lhs.posts == rhs.posts
            && lhs.error == rhs.error
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension SearchPostsState: ObservableObject {}
#endif
