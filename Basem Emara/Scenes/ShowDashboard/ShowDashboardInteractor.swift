//
//  ShowDashboardInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

struct ShowDashboardInteractor: ShowDashboardBusinessLogic {
    private let presenter: ShowDashboardPresentable
    private let postWorker: PostWorkerType
    private let mediaWorker: MediaWorkerType
    private let taxonomyWorker: TaxonomyWorkerType
    private let preferences: PreferencesType

    init(
        presenter: ShowDashboardPresentable,
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

extension ShowDashboardInteractor {
    
    func fetchLatestPosts(with request: ShowDashboardModels.FetchPostsRequest) {
        postWorker.fetch {
            guard case .success(let value) = $0 else {
                return self.presenter.presentLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            let posts = value.prefix(request.count).array
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentLatestPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentLatestPosts(
                    for: ShowDashboardModels.PostsResponse(
                        posts: posts,
                        media: media,
                        favorites: self.preferences.favorites
                    )
                )
            }
        }
    }
    
    func fetchPopularPosts(with request: ShowDashboardModels.FetchPostsRequest) {
        postWorker.fetchPopular {
            guard case .success(let value) = $0 else {
                return self.presenter.presentPopularPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            let posts = value.prefix(request.count).array
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentPopularPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentPopularPosts(
                    for: ShowDashboardModels.PostsResponse(
                        posts: posts,
                        media: media,
                        favorites: self.preferences.favorites
                    )
                )
            }
        }
    }
    
    func fetchTopPickPosts(with request: ShowDashboardModels.FetchPostsRequest) {
        postWorker.fetchTopPicks {
            guard case .success(let value) = $0 else {
                return self.presenter.presentTopPickPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            let posts = value.prefix(request.count).array
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentTopPickPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentTopPickPosts(
                    for: ShowDashboardModels.PostsResponse(
                        posts: posts,
                        media: media,
                        favorites: self.preferences.favorites
                    )
                )
            }
        }
    }
}

extension ShowDashboardInteractor {
    
    func fetchTerms(with request: ShowDashboardModels.FetchTermsRequest) {
        taxonomyWorker.fetch(by: [.category, .tag]) {
            guard case .success(let value) = $0 else {
                return self.presenter.presentTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            let terms = value
                .sorted { $0.count > $1.count }
                .prefix(request.count)
                .array
            
            self.presenter.presentTerms(
                for: ShowDashboardModels.TermsResponse(
                    terms: terms
                )
            )
        }
    }
}

extension ShowDashboardInteractor {
    
    func toggleFavorite(with request: ShowDashboardModels.FavoriteRequest) {
        postWorker.toggleFavorite(id: request.postID)
        
        presenter.presentToggleFavorite(
            for: ShowDashboardModels.FavoriteResponse(
                postID: request.postID,
                favorite: postWorker.hasFavorite(id: request.postID)
            )
        )
    }
}
