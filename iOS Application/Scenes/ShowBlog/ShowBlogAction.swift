//
//  ShowBlogInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamCore

struct ShowBlogAction: ShowBlogActionable {
    private let presenter: ShowBlogPresentable
    private let postWorker: PostWorkerType
    private let mediaWorker: MediaWorkerType
    private let taxonomyWorker: TaxonomyWorkerType
    private let preferences: PreferencesType

    init(
        presenter: ShowBlogPresentable,
        postWorker: PostWorkerType,
        mediaWorker: MediaWorkerType,
        taxonomyWorker: TaxonomyWorkerType,
        preferences: PreferencesType
    ) {
        self.presenter = presenter
        self.postWorker = postWorker
        self.mediaWorker = mediaWorker
        self.taxonomyWorker = taxonomyWorker
        self.preferences = preferences
    }
}

extension ShowBlogAction {
    
    func fetchLatestPosts(with request: ShowBlogAPI.FetchPostsRequest) {
        let request = PostsAPI.FetchRequest(maxLength: request.maxLength)
        
        postWorker.fetch(with: request) {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentLatestPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentLatestPosts(
                    for: ShowBlogAPI.PostsResponse(
                        posts: posts,
                        media: media,
                        favorites: self.preferences.favorites
                    )
                )
            }
        }
    }
    
    func fetchPopularPosts(with request: ShowBlogAPI.FetchPostsRequest) {
        let request = PostsAPI.FetchRequest(maxLength: request.maxLength)
        
        postWorker.fetchPopular(with: request) {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentPopularPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentPopularPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentPopularPosts(
                    for: ShowBlogAPI.PostsResponse(
                        posts: posts,
                        media: media,
                        favorites: self.preferences.favorites
                    )
                )
            }
        }
    }
    
    func fetchTopPickPosts(with request: ShowBlogAPI.FetchPostsRequest) {
        let request = PostsAPI.FetchRequest(maxLength: request.maxLength)
        
        postWorker.fetchTopPicks(with: request) {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentTopPickPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentTopPickPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentTopPickPosts(
                    for: ShowBlogAPI.PostsResponse(
                        posts: posts,
                        media: media,
                        favorites: self.preferences.favorites
                    )
                )
            }
        }
    }
}

extension ShowBlogAction {
    
    func fetchTerms(with request: ShowBlogAPI.FetchTermsRequest) {
        taxonomyWorker.fetch(by: [.category, .tag]) {
            guard case .success(let value) = $0 else {
                return self.presenter.presentTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            let terms = value
                .sorted { $0.count > $1.count }
                .prefix(request.maxLength)
                .array
            
            self.presenter.presentTerms(
                for: ShowBlogAPI.TermsResponse(
                    terms: terms
                )
            )
        }
    }
}

extension ShowBlogAction {
    
    func toggleFavorite(with request: ShowBlogAPI.FavoriteRequest) {
        postWorker.toggleFavorite(id: request.postID)
        
        presenter.presentToggleFavorite(
            for: ShowBlogAPI.FavoriteResponse(
                postID: request.postID,
                favorite: postWorker.hasFavorite(id: request.postID)
            )
        )
    }
}