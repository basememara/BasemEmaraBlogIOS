//
//  ShowBlogState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-14.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress
import ZamzamUI

class ShowBlogState: StateRepresentable {
    private let postsState: PostsState
    private let termsState: TermsState
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    fileprivate(set) var latestPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != latestPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != latestPosts else { return }
            notificationPost(for: \Self.latestPosts)
        }
    }
    
    fileprivate(set) var popularPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != popularPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != popularPosts else { return }
            notificationPost(for: \Self.popularPosts)
        }
    }
    
    fileprivate(set) var topPickPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != topPickPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != topPickPosts else { return }
            notificationPost(for: \Self.topPickPosts)
        }
    }
    
    fileprivate(set) var terms: [TermsDataViewModel] = [] {
        willSet {
            guard newValue != terms, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != terms else { return }
            notificationPost(for: \Self.terms)
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
    
    init(postsState: PostsState, termsState: TermsState) {
        self.postsState = postsState
        self.termsState = termsState
    }
}

extension ShowBlogState {
    
    func subscribe(_ observer: @escaping (StateChange<ShowBlogState>) -> Void) {
        subscribe(observer, in: &cancellable)
        postsState.subscribe(postsLoad, in: &cancellable)
        termsState.subscribe(termsLoad, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

private extension ShowBlogState {
    
    func postsLoad(_ result: StateChange<PostsState>) {
        // Retrieve latest changes from root state and let equatable determine if current state changed
        guard result == .updated(\PostsState.allPosts) || result == .initial else { return }
        latestPosts = latestPosts.compactMap { postsState.allPosts[$0.id] }
        popularPosts = popularPosts.compactMap { postsState.allPosts[$0.id] }
        topPickPosts = topPickPosts.compactMap { postsState.allPosts[$0.id] }
    }
    
    func termsLoad(_ result: StateChange<TermsState>) {
        // Retrieve latest changes from root state and let equatable determine if current state changed
        guard result == .updated(\TermsState.allTerms) || result == .initial else { return }
        terms = terms.compactMap { termsState.allTerms[$0.id] }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ShowBlogState: ObservableObject {}
#endif

// MARK: - Reducer

enum ShowBlogReducer: Reducer {
    case loadLatestPosts([PostsDataViewModel])
    case loadPopularPosts([PostsDataViewModel])
    case loadTopPickPosts([PostsDataViewModel])
    case loadTerms([TermsDataViewModel])
    case toggleFavorite(ShowBlogAPI.FavoriteViewModel)
    case loadError(ViewError)
}

extension AppStore {
    
    func reduce(_ reducer: ShowBlogReducer) {
        switch reducer {
        case .loadLatestPosts(let items):
            showBlogState.latestPosts = items
            reduce(.mergePosts(items))
        case .loadPopularPosts(let items):
            showBlogState.popularPosts = items
            reduce(.mergePosts(items))
        case .loadTopPickPosts(let items):
            showBlogState.topPickPosts = items
            reduce(.mergePosts(items))
        case .loadTerms(let items):
            showBlogState.terms = items
            reduce(.mergeTerms(items))
        case .toggleFavorite(let item):
            reduce(
                .toggleFavorite(
                    postID: item.postID,
                    favorite: item.favorite
                )
            )
        case .loadError(let item):
            showBlogState.error = item
        }
    }
}
