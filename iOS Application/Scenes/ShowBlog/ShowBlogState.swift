//
//  ShowBlogState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-14.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

class ShowBlogState: StateRepresentable {
    
    private(set) var latestPosts: [PostsDataViewModel] = [] {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowBlogState.latestPosts) }
    }
    
    private(set) var popularPosts: [PostsDataViewModel] = [] {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowBlogState.popularPosts) }
    }
    
    private(set) var topPickPosts: [PostsDataViewModel] = [] {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowBlogState.topPickPosts) }
    }
    
    private(set) var terms: [TermsDataViewModel] = [] {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowBlogState.terms) }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowBlogState.error) }
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
            latestPosts = items
        case .loadPopularPosts(let items):
            popularPosts = items
        case .loadTopPickPosts(let items):
            topPickPosts = items
        case .loadTerms(let items):
            terms = items
        case .toggleFavorite(let item):
            if let index = latestPosts
                .firstIndex(where: { $0.id == item.postID }) {
                //latestPosts[index] = PostsDataViewModel(
            }
            
            if let index = popularPosts
                .firstIndex(where: { $0.id == item.postID }) {
                //popularPosts[index] = PostsDataViewModel(
            }
            
            if let index = topPickPosts
                .firstIndex(where: { $0.id == item.postID }) {
                //topPickPosts[index] = PostsDataViewModel(
            }
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
