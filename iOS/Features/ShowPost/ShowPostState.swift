//
//  ShowPostState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-27.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress
import ZamzamUI

class ShowPostState: StateRepresentable {
    private let postsState: PostsState
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    fileprivate(set) var web: ShowPostAPI.WebViewModel? {
        willSet {
            guard newValue != web, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != web else { return }
            notificationPost(for: \Self.web)
        }
    }
    
    fileprivate(set) var post: ShowPostAPI.PostViewModel? {
        willSet {
            guard newValue != post, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != post else { return }
            notificationPost(for: \Self.post)
        }
    }
    
    fileprivate(set) var isFavorite: Bool = false {
        willSet {
            guard newValue != isFavorite, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != isFavorite else { return }
            notificationPost(for: \Self.isFavorite)
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

extension ShowPostState {
    
    func subscribe(_ observer: @escaping (StateChange<ShowPostState>) -> Void) {
        subscribe(observer, in: &cancellable)
        postsState.subscribe(postsLoad, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

private extension ShowPostState {
    
    func postsLoad(_ result: StateChange<PostsState>) {
        guard let id = post?.id,
            result == .updated(\PostsState.allPosts)
                || result == .initial else {
                    return
        }
        
        isFavorite = postsState.allPosts[id]?.favorite ?? false
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ShowPostState: ObservableObject {}
#endif

// MARK: - Reducer

enum ShowPostReducer: Reducer {
    case loadWeb(ShowPostAPI.WebViewModel)
    case loadPost(ShowPostAPI.PostViewModel)
    case loadFavorite(Bool)
    case toggleFavorite(Bool)
    case loadError(ViewError)
}

extension AppStore {
    
    func reduce(_ reducer: ShowPostReducer) {
        switch reducer {
        case .loadWeb(let item):
            showPostState.web = item
        case .loadPost(let item):
            showPostState.post = item
        case .loadFavorite(let item):
            showPostState.isFavorite = item
        case .toggleFavorite(let item):
            guard let id = showPostState.post?.id else { return }
            
            reduce(
                .toggleFavorite(
                    postID: id,
                    favorite: item
                )
            )
        case .loadError(let item):
            showPostState.error = item
        }
    }
}
