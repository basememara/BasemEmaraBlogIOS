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
    private let appState: AppState
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
    
    init(appState: AppState) {
        self.appState = appState
    }
}

extension ShowPostState {
    
    func subscribe(_ observer: @escaping (PartialKeyPath<ShowPostState>?) -> Void) {
        subscribe(observer, in: &cancellable)
        appState.subscribe(load, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

private extension ShowPostState {
    
    func load(_ keyPath: PartialKeyPath<AppState>?) {
        if keyPath == \AppState.allPosts || keyPath == nil {
            isFavorite = appState.allPosts.first { $0.id == post?.id }?.favorite ?? false
        }
    }
}

// MARK: - Action

enum ShowPostAction: Action {
    case loadWeb(ShowPostAPI.WebViewModel)
    case loadPost(ShowPostAPI.PostViewModel)
    case loadFavorite(Bool)
    case toggleFavorite(Bool)
    case loadError(ViewError?)
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
            guard let current = appState.allPosts
                .first(where: { $0.id == post?.id })?
                .toggled(favorite: item) else {
                    return
            }
            
            appState(.mergePosts([current]))
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
