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
        willSet {
            guard newValue != posts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != posts else { return }
            notificationPost(keyPath: \SearchPostsState.posts)
        }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet {
            guard newValue != error, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != error else { return }
            notificationPost(keyPath: \SearchPostsState.error)
        }
    }
}

// MARK: - Action

enum SearchPostsAction: Action {
    case loadPosts([PostsDataViewModel])
    case loadError(AppAPI.Error?)
}

// MARK: - Reducer

extension SearchPostsState {
    
    func callAsFunction(_ action: SearchPostsAction) {
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
