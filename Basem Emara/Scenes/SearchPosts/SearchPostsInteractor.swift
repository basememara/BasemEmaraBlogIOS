//
//  SearchPostsInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct SearchPostsInteractor: SearchPostsBusinessLogic {
    private let presenter: SearchPostsPresentable
    private let postWorker: PostWorkerType
    private let mediaWorker: MediaWorkerType
    
    init(presenter: SearchPostsPresentable,
         postWorker: PostWorkerType,
         mediaWorker: MediaWorkerType) {
        self.presenter = presenter
        self.postWorker = postWorker
        self.mediaWorker = mediaWorker
    }
}

extension SearchPostsInteractor {

    func fetchSearchResults(with request: PostsModels.SearchRequest) {
        postWorker.search(with: request) {
            guard let posts = $0.value, $0.isSuccess else {
                return self.presenter.presentSearchResults(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else {
                    return self.presenter.presentSearchResults(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentSearchResults(
                    for: SearchPostsModels.Response(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension SearchPostsInteractor {
    
    func fetchPopularPosts(with request: SearchPostsModels.PopularRequest) {
        postWorker.fetchPopular {
            guard let posts = $0.value, $0.isSuccess else {
                return self.presenter.presentSearchResults(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else {
                    return self.presenter.presentSearchResults(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentSearchResults(
                    for: SearchPostsModels.Response(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}
