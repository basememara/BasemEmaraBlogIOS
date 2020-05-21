//
//  ShowPostState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-27.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress

class ShowPostState: StateRepresentable {
    private let sharedState: SharedState
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var web: ShowPostAPI.WebViewModel? {
        willSet {
            guard newValue != web, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != web else { return }
            notificationPost(keyPath: \ShowPostState.web)
        }
    }
    
    private(set) var post: ShowPostAPI.PostViewModel? {
        willSet {
            guard newValue != post, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != post else { return }
            notificationPost(keyPath: \ShowPostState.post)
        }
    }
    
    private(set) var isFavorite: Bool = false {
        willSet {
            guard newValue != isFavorite, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != isFavorite else { return }
            notificationPost(keyPath: \ShowPostState.isFavorite)
        }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet {
            guard newValue != error, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != error else { return }
            notificationPost(keyPath: \ShowPostState.error)
        }
    }
    
    // MARK: - Initializers
    
    init(sharedState: SharedState) {
        self.sharedState = sharedState
        self.sharedState.subscribe(load, in: &cancellable)
    }
}

private extension ShowPostState {
    
    func load(_ keyPath: PartialKeyPath<SharedState>?) {
        if keyPath == \SharedState.posts || keyPath == nil {
            isFavorite = sharedState.posts.first { $0.id == post?.id }?.favorite ?? false
        }
    }
}

// MARK: - Action

enum ShowPostAction: Action {
    case loadWeb(ShowPostAPI.WebViewModel)
    case loadPost(ShowPostAPI.PostViewModel)
    case loadFavorite(Bool)
    case toggleFavorite(Bool)
    case loadError(AppAPI.Error?)
}

// MARK: - Reducer

extension ShowPostState {
    
    func callAsFunction(_ action: ShowPostAction) {
        switch action {
        case .loadWeb(let item):
            web = item
        case .loadPost(let item):
            post = item
        case .loadFavorite(let item):
            isFavorite = item
        case .toggleFavorite(let item):
            guard let current = sharedState.posts
                .first(where: { $0.id == post?.id })?
                .toggled(favorite: item) else {
                    return
            }
            
            sharedState(.mergePosts([current]))
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - Conformances

extension ShowPostState: Equatable {
    
    static func == (lhs: ShowPostState, rhs: ShowPostState) -> Bool {
        lhs.web == rhs.web
            && lhs.post == rhs.post
            && lhs.isFavorite == rhs.isFavorite
            && lhs.error == rhs.error
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ShowPostState: ObservableObject {}
#endif
