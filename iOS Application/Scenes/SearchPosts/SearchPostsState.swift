//
//  SearchPostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress

class SearchPostsState: StateRepresentable {
    private var cancellable: NotificationCenter.Cancellable?
    
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
}

extension SearchPostsState {
    
    func subscribe(_ observer: @escaping (PartialKeyPath<SearchPostsState>?) -> Void) {
        subscribe(observer, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

// MARK: - Action

enum SearchPostsAction: Action {
    case loadPosts([PostsDataViewModel])
    case loadError(ViewError?)
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

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension SearchPostsState: ObservableObject {}
#endif
