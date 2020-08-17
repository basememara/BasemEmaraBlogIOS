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
    
    private(set) var web: ShowPostAPI.WebViewModel? {
        willSet {
            guard newValue != web, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != web else { return }
            notificationPost(for: \Self.web)
        }
    }
    
    private(set) var post: ShowPostAPI.PostViewModel? {
        willSet {
            guard newValue != post, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != post else { return }
            notificationPost(for: \Self.post)
        }
    }
    
    private(set) var isFavorite: Bool = false {
        willSet {
            guard newValue != isFavorite, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != isFavorite else { return }
            notificationPost(for: \Self.isFavorite)
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

// MARK: - Reducer

enum ShowPostReducer: Reducer {
    case loadWeb(ShowPostAPI.WebViewModel)
    case loadPost(ShowPostAPI.PostViewModel)
    case loadFavorite(Bool)
    case toggleFavorite(Bool)
    case loadError(ViewError)
}

extension ShowPostState {
    
    func callAsFunction(_ reducer: ShowPostReducer) {
        switch reducer {
        case .loadWeb(let item):
            web = item
        case .loadPost(let item):
            post = item
        case .loadFavorite(let item):
            isFavorite = item
        case .toggleFavorite(let item):
            guard let id = post?.id else { return }
            
            postsState(
                .toggleFavorite(
                    postID: id,
                    favorite: item
                )
            )
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ShowPostState: ObservableObject {}
#endif
