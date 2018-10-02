//
//  ListPostsInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListPostsInteractor: ListPostsBusinessLogic {
    private let presenter: ListPostsPresentable
    private let postsWorker: PostsWorkerType
    private let mediaWorker: MediaWorkerType
    
    init(presenter: ListPostsPresentable,
         postsWorker: PostsWorkerType,
         mediaWorker: MediaWorkerType) {
        self.presenter = presenter
        self.postsWorker = postsWorker
        self.mediaWorker = mediaWorker
    }
}

extension ListPostsInteractor {
    
    func fetchLatestPosts(with request: ListPostsModels.FetchPostsRequest) {
        postsWorker.fetch {
            guard let posts = $0.value, $0.isSuccess else {
                return self.presenter.presentLatestPosts(
                    error: $0.error ?? DataError.unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else {
                    return self.presenter.presentLatestPosts(
                        error: $0.error ?? DataError.unknownReason(nil)
                    )
                }
                
                self.presenter.presentLatestPosts(
                    for: ListPostsModels.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func fetchPopularPosts(with request: ListPostsModels.FetchPostsRequest) {
        postsWorker.fetchPopular {
            guard let posts = $0.value, $0.isSuccess else {
                return self.presenter.presentPopularPosts(
                    error: $0.error ?? DataError.unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else {
                    return self.presenter.presentPopularPosts(
                        error: $0.error ?? DataError.unknownReason(nil)
                    )
                }
                
                self.presenter.presentPopularPosts(
                    for: ListPostsModels.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func fetchTopPickPosts(with request: ListPostsModels.FetchPostsRequest) {
        postsWorker.fetchTopPicks {
            guard let posts = $0.value, $0.isSuccess else {
                return self.presenter.presentTopPickPosts(
                    error: $0.error ?? DataError.unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else {
                    return self.presenter.presentTopPickPosts(
                        error: $0.error ?? DataError.unknownReason(nil)
                    )
                }
                
                self.presenter.presentTopPickPosts(
                    for: ListPostsModels.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func fetchPostsByTerms(with request: ListPostsModels.FetchPostsByTermsRequest) {
        postsWorker.fetch(byTermIDs: request.ids) {
            guard let posts = $0.value, $0.isSuccess else {
                return self.presenter.presentPostsByTerms(
                    error: $0.error ?? DataError.unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard let media = $0.value, $0.isSuccess else {
                    return self.presenter.presentPostsByTerms(
                        error: $0.error ?? DataError.unknownReason(nil)
                    )
                }
                
                self.presenter.presentPostsByTerms(
                    for: ListPostsModels.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}
