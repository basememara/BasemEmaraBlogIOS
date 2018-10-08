//
//  HomeInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct HomeInteractor: HomeBusinessLogic {
    private let presenter: HomePresentable
    private let postsWorker: PostsWorkerType
    private let mediaWorker: MediaWorkerType
    private let taxonomyWorker: TaxonomyWorkerType
    private let preferences: PreferencesType

    init(presenter: HomePresentable,
         postsWorker: PostsWorkerType,
         mediaWorker: MediaWorkerType,
         taxonomyWorker: TaxonomyWorkerType,
         preferences: PreferencesType) {
        self.presenter = presenter
        self.postsWorker = postsWorker
        self.mediaWorker = mediaWorker
        self.taxonomyWorker = taxonomyWorker
        self.preferences = preferences
    }
}

extension HomeInteractor {
    
    func fetchLatestPosts(with request: HomeModels.FetchPostsRequest) {
        postsWorker.fetch {
            guard let posts = $0.value, $0.isSuccess else {
                return self.presenter.presentLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else {
                    return self.presenter.presentLatestPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentLatestPosts(
                    for: HomeModels.PostsResponse(
                        posts: posts.prefix(request.count).array,
                        media: media,
                        favorites: self.preferences.get(.favorites) ?? []
                    )
                )
            }
        }
    }
    
    func fetchPopularPosts(with request: HomeModels.FetchPostsRequest) {
        postsWorker.fetchPopular {
            guard let posts = $0.value, $0.isSuccess else {
                return self.presenter.presentPopularPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else {
                    return self.presenter.presentPopularPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentPopularPosts(
                    for: HomeModels.PostsResponse(
                        posts: posts.prefix(request.count).array,
                        media: media,
                        favorites: self.preferences.get(.favorites) ?? []
                    )
                )
            }
        }
    }
    
    func fetchTopPickPosts(with request: HomeModels.FetchPostsRequest) {
        postsWorker.fetchTopPicks {
            guard let posts = $0.value, $0.isSuccess else {
                return self.presenter.presentTopPickPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else {
                    return self.presenter.presentTopPickPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentTopPickPosts(
                    for: HomeModels.PostsResponse(
                        posts: posts.prefix(request.count).array,
                        media: media,
                        favorites: self.preferences.get(.favorites) ?? []
                    )
                )
            }
        }
    }
}

extension HomeInteractor {
    
    func fetchTerms(with request: HomeModels.FetchTermsRequest) {
        taxonomyWorker.fetch {
            guard let terms = $0.value?.sorted(by: { $0.count > $1.count }), $0.isSuccess else {
                return self.presenter.presentTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.presenter.presentTerms(
                for: HomeModels.TermsResponse(
                    terms: terms.prefix(request.count).array
                )
            )
        }
    }
}
