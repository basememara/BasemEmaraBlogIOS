//
//  ListPostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress
import ZamzamUI

class ListPostsState: StateRepresentable {
    private let postsState: PostsState
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
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
    
    init(postsState: PostsState) {
        self.postsState = postsState
    }
}

extension ListPostsState {
    
    func subscribe(_ observer: @escaping (StateChange<ListPostsState>) -> Void) {
        subscribe(observer, in: &cancellable)
        postsState.subscribe(postsLoad, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

private extension ListPostsState {
    
    func postsLoad(_ result: StateChange<PostsState>) {
        guard result == .updated(\PostsState.allPosts) || result == .initial else { return }
        posts = posts.compactMap { postsState.allPosts[$0.id] }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ListPostsState: ObservableObject {}
#endif

// MARK: - Reducer

enum ListPostsReducer: Reducer {
    case loadPosts([PostsDataViewModel])
    case toggleFavorite(ListPostsAPI.FavoriteViewModel)
    case loadError(ViewError)
}

extension AppStore {
    
    func reduce(_ reducer: ListPostsReducer) {
        switch reducer {
        case .loadPosts(let items):
            listPostsState.posts = items
            reduce(.mergePosts(items))
        case .toggleFavorite(let item):
            reduce(
                .toggleFavorite(
                    postID: item.postID,
                    favorite: item.favorite
                )
            )
        case .loadError(let item):
            listPostsState.error = item
        }
    }
}
