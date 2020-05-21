//
//  ShowBlogState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-14.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress

class ShowBlogState: StateRepresentable {
    private let appState: AppState
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var latestPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != latestPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != latestPosts else { return }
            notificationPost(for: \Self.latestPosts)
        }
    }
    
    private(set) var popularPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != popularPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != popularPosts else { return }
            notificationPost(for: \Self.popularPosts)
        }
    }
    
    private(set) var topPickPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != topPickPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != topPickPosts else { return }
            notificationPost(for: \Self.topPickPosts)
        }
    }
    
    private(set) var terms: [TermsDataViewModel] = [] {
        willSet {
            guard newValue != terms, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != terms else { return }
            notificationPost(for: \Self.terms)
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

extension ShowBlogState {
    
    func subscribe(_ observer: @escaping (PartialKeyPath<ShowBlogState>?) -> Void) {
        subscribe(observer, in: &cancellable)
        appState.subscribe(load, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

private extension ShowBlogState {
    
    func load(_ keyPath: PartialKeyPath<AppState>?) {
        if keyPath == \AppState.allPosts || keyPath == nil {
            latestPosts = latestPosts.compactMap { posts in appState.allPosts.first { $0.id == posts.id } }
            popularPosts = popularPosts.compactMap { posts in appState.allPosts.first { $0.id == posts.id } }
            topPickPosts = topPickPosts.compactMap { posts in appState.allPosts.first { $0.id == posts.id } }
        }
        
        if keyPath == \AppState.allTerms || keyPath == nil {
            terms = terms.compactMap { term in appState.allTerms.first { $0.id == term.id } }
        }
    }
}

// MARK: - Action

enum ShowBlogAction: Action {
    case loadLatestPosts([PostsDataViewModel])
    case loadPopularPosts([PostsDataViewModel])
    case loadTopPickPosts([PostsDataViewModel])
    case loadTerms([TermsDataViewModel])
    case toggleFavorite(ShowBlogAPI.FavoriteViewModel)
    case loadError(ViewError?)
}

// MARK: - Reducer

extension ShowBlogState {
    
    func callAsFunction(_ action: ShowBlogAction) {
        switch action {
        case .loadLatestPosts(let items):
            latestPosts = items
            appState(.mergePosts(items))
        case .loadPopularPosts(let items):
            popularPosts = items
            appState(.mergePosts(items))
        case .loadTopPickPosts(let items):
            topPickPosts = items
            appState(.mergePosts(items))
        case .loadTerms(let items):
            terms = items
            appState(.mergeTerms(items))
        case .toggleFavorite(let item):
            guard let current = appState.allPosts
                .first(where: { $0.id == item.postID })?
                .toggled(favorite: item.favorite) else {
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
extension ShowBlogState: ObservableObject {}
#endif
