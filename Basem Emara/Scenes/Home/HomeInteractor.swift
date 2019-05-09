//
//  HomeInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

struct HomeInteractor: HomeBusinessLogic {
    private let presenter: HomePresentable
    private let postWorker: PostWorkerType
    private let mediaWorker: MediaWorkerType
    private let taxonomyWorker: TaxonomyWorkerType
    private let preferences: PreferencesType

    init(presenter: HomePresentable,
         postWorker: PostWorkerType,
         mediaWorker: MediaWorkerType,
         taxonomyWorker: TaxonomyWorkerType,
         preferences: PreferencesType) {
        self.presenter = presenter
        self.postWorker = postWorker
        self.mediaWorker = mediaWorker
        self.taxonomyWorker = taxonomyWorker
        self.preferences = preferences
    }
}

extension HomeInteractor {
    
    func fetchLatestPosts(with request: HomeModels.FetchPostsRequest) {
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
                    for: HomeModels.PostsResponse(
                        posts: posts,
                        media: media,
                        favorites: self.preferences.favorites
                    )
                )
            }
        }
    }
    
    func fetchPopularPosts(with request: HomeModels.FetchPostsRequest) {
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
                    for: HomeModels.PostsResponse(
                        posts: posts,
                        media: media,
                        favorites: self.preferences.favorites
                    )
                )
            }
        }
    }
    
    func fetchTopPickPosts(with request: HomeModels.FetchPostsRequest) {
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
                    for: HomeModels.PostsResponse(
                        posts: posts,
                        media: media,
                        favorites: self.preferences.favorites
                    )
                )
            }
        }
    }
}

extension HomeInteractor {
    
    func fetchTerms(with request: HomeModels.FetchTermsRequest) {
        taxonomyWorker.fetch {
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
                for: HomeModels.TermsResponse(
                    terms: terms
                )
            )
        }
    }
}

extension HomeInteractor {
    
    func toggleFavorite(with request: HomeModels.FavoriteRequest) {
        postWorker.toggleFavorite(id: request.postID)
        
        presenter.presentToggleFavorite(
            for: HomeModels.FavoriteResponse(
                postID: request.postID,
                favorite: postWorker.hasFavorite(id: request.postID)
            )
        )
    }
}
