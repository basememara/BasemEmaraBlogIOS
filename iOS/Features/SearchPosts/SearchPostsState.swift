//
//  SearchPostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress
import ZamzamUI

class SearchPostsState: StateRepresentable {
    private var cancellable: NotificationCenter.Cancellable?
    
    fileprivate(set) var posts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != posts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != posts else { return }
            notificationPost(for: \Self.posts)
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
}

extension SearchPostsState {
    
    func subscribe(_ observer: @escaping (StateChange<SearchPostsState>) -> Void) {
        subscribe(observer, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension SearchPostsState: ObservableObject {}
#endif

// MARK: - Reducer

enum SearchPostsReducer: Reducer {
    case loadPosts([PostsDataViewModel])
    case loadError(ViewError)
}

extension AppStore {
    
    func reduce(_ reducer: SearchPostsReducer) {
        switch reducer {
        case .loadPosts(let items):
            searchPostsState.posts = items
        case .loadError(let item):
            searchPostsState.error = item
        }
    }
}
