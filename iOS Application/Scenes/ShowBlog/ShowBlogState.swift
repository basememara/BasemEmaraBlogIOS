//
//  ShowBlogState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-14.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ShowBlogState: State {
    private(set) var latestPosts: [PostsDataViewModel] = []
    private(set) var popularPosts: [PostsDataViewModel] = []
    private(set) var topPickPosts: [PostsDataViewModel] = []
    private(set) var terms: [TermsDataViewModel] = []
    private(set) var error: AppAPI.Error?
}

// MARK: - Reducer

extension ShowBlogState {
    
    enum ShowBlogAction: Action {
        case loadLatestPosts([PostsDataViewModel])
        case loadPopularPosts([PostsDataViewModel])
        case loadTopPickPosts([PostsDataViewModel])
        case loadTerms([TermsDataViewModel])
        case toggleFavorite(ShowBlogAPI.FavoriteViewModel)
        case loadError(AppAPI.Error?)
    }
    
    mutating func receive(_ action: ShowBlogAction) {
        switch action {
        case .loadLatestPosts(let value):
            latestPosts = value
        case .loadPopularPosts(let value):
            popularPosts = value
        case .loadTopPickPosts(let value):
            topPickPosts = value
        case .loadTerms(let value):
            terms = value
        case .toggleFavorite(let value):
            if let index = latestPosts
                .firstIndex(where: { $0.id == value.postID }) {
                //latestPosts[index] = PostsDataViewModel(
            }
            
            if let index = popularPosts
                .firstIndex(where: { $0.id == value.postID }) {
                //popularPosts[index] = PostsDataViewModel(
            }
            
            if let index = topPickPosts
                .firstIndex(where: { $0.id == value.postID }) {
                //topPickPosts[index] = PostsDataViewModel(
            }
        case .loadError(let value):
            error = value
        }
    }
}
