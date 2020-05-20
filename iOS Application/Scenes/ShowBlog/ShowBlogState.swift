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
    private let sharedState: SharedState
    private var latestPostIDs: [Int] = []
    private var popularPostIDs: [Int] = []
    private var topPickPostIDs: [Int] = []
    private var termIDs: [Int] = []
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var latestPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != latestPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != latestPosts else { return }
            notificationPost(keyPath: \ShowBlogState.latestPosts)
        }
    }
    
    private(set) var popularPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != popularPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != popularPosts else { return }
            notificationPost(keyPath: \ShowBlogState.popularPosts)
        }
    }
    
    private(set) var topPickPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != topPickPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != topPickPosts else { return }
            notificationPost(keyPath: \ShowBlogState.topPickPosts)
        }
    }
    
    private(set) var terms: [TermsDataViewModel] = [] {
        willSet {
            guard newValue != terms, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != terms else { return }
            notificationPost(keyPath: \ShowBlogState.terms)
        }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet {
            guard newValue != error, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != error else { return }
            notificationPost(keyPath: \ShowBlogState.error)
        }
    }
    
    // MARK: - Initializers
    
    init(sharedState: SharedState) {
        self.sharedState = sharedState
        self.sharedState.subscribe(load, in: &cancellable)
    }
}

private extension ShowBlogState {
    
    func load(_ keyPath: PartialKeyPath<SharedState>?) {
        if keyPath == \SharedState.posts || keyPath == nil {
            latestPosts = latestPostIDs.compactMap { id in sharedState.posts.first { $0.id == id } }
            popularPosts = popularPostIDs.compactMap { id in sharedState.posts.first { $0.id == id } }
            topPickPosts = topPickPostIDs.compactMap { id in sharedState.posts.first { $0.id == id } }
        }
        
        if keyPath == \SharedState.terms || keyPath == nil {
            terms = termIDs.compactMap { id in sharedState.terms.first { $0.id == id } }
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
    case loadError(AppAPI.Error?)
}

// MARK: - Reducer

extension ShowBlogState {
    
    func reduce(_ action: ShowBlogAction) {
        switch action {
        case .loadLatestPosts(let items):
            latestPostIDs = items.map(\.id)
            sharedState.reduce(.mergePosts(items))
        case .loadPopularPosts(let items):
            popularPostIDs = items.map(\.id)
            sharedState.reduce(.mergePosts(items))
        case .loadTopPickPosts(let items):
            topPickPostIDs = items.map(\.id)
            sharedState.reduce(.mergePosts(items))
        case .loadTerms(let items):
            termIDs = items.map(\.id)
            sharedState.reduce(.mergeTerms(items))
        case .toggleFavorite(let item):
            guard let current = sharedState.posts
                .first(where: { $0.id == item.postID })?
                .toggled(favorite: item.favorite) else {
                    return
            }
            
            sharedState.reduce(.mergePosts([current]))
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - Conformances

extension ShowBlogState: Equatable {
    
    static func == (lhs: ShowBlogState, rhs: ShowBlogState) -> Bool {
        lhs.latestPosts == rhs.latestPosts
            && lhs.popularPosts == rhs.popularPosts
            && lhs.topPickPosts == rhs.topPickPosts
            && lhs.terms == rhs.terms
            && lhs.error == rhs.error
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ShowBlogState: ObservableObject {}
#endif
