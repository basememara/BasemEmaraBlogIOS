//
//  ShowPostInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ShowPostInteractor: ShowPostBusinessLogic {
    private let presenter: ShowPostPresentable
    private let postsWorker: PostsWorkerType
    private let mediaWorker: MediaWorkerType
    private let authorsWorker: AuthorsWorkerType
    private let taxonomyWorker: TaxonomyWorkerType
    
    init(presenter: ShowPostPresentable,
         postsWorker: PostsWorkerType,
         mediaWorker: MediaWorkerType,
         authorsWorker: AuthorsWorkerType,
         taxonomyWorker: TaxonomyWorkerType) {
        self.presenter = presenter
        self.postsWorker = postsWorker
        self.mediaWorker = mediaWorker
        self.authorsWorker = authorsWorker
        self.taxonomyWorker = taxonomyWorker
    }
}

extension ShowPostInteractor {
    
    func fetchPost(with request: ShowPostModels.Request) {
        postsWorker.fetch(id: request.postID) {
            guard let post = $0.value, $0.isSuccess else {
                return self.presenter.presentPost(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(id: post.mediaID ?? 0) {
                guard $0.isSuccess else {
                    return self.presenter.presentPost(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
            
                let media = $0.value
                let termIDs: Set = Set(post.categories + post.tags)
                
                self.taxonomyWorker.fetch(ids: termIDs) {
                    guard let terms = $0.value, $0.isSuccess else {
                        return self.presenter.presentPost(
                            error: $0.error ?? .unknownReason(nil)
                        )
                    }
                
                    self.authorsWorker.fetch(id: post.authorID) {
                        guard $0.isSuccess else {
                            return self.presenter.presentPost(
                                error: $0.error ?? .unknownReason(nil)
                            )
                        }
                        
                        let author = $0.value
                        
                        self.presenter.presentPost(
                            for: ShowPostModels.Response(
                                post: post,
                                media: media,
                                categories: terms.filter { $0.taxonomy == .category },
                                tags: terms.filter { $0.taxonomy == .tag },
                                author: author
                            )
                        )
                    }
                }
            }
        }
    }
}

extension ShowPostInteractor {
    
    func fetchByURL(with request: ShowPostModels.FetchWebRequest) {
        postsWorker.fetch(url: request.url) {
            // Handle if URL is not for a post
            if case .nonExistent? = $0.error {
                self.taxonomyWorker.fetch(url: request.url) {
                    guard let term = $0.value, $0.isSuccess else {
                        // URL could not be found
                        return self.presenter.presentByURL(
                            for: ShowPostModels.FetchWebResponse(
                                post: nil,
                                term: nil,
                                decisionHandler: request.decisionHandler
                            )
                        )
                    }
                    
                    // URL was a taxonomy term
                    self.presenter.presentByURL(
                        for: ShowPostModels.FetchWebResponse(
                            post: nil,
                            term: term,
                            decisionHandler: request.decisionHandler
                        )
                    )
                }
                
                return
            }
            
            guard let post = $0.value, $0.isSuccess else {
                // URL could not be found
                return self.presenter.presentByURL(
                    for: ShowPostModels.FetchWebResponse(
                        post: nil,
                        term: nil,
                        decisionHandler: request.decisionHandler
                    )
                )
            }
            
            // URL was a post
            self.presenter.presentByURL(
                for: ShowPostModels.FetchWebResponse(
                    post: post,
                    term: nil,
                    decisionHandler: request.decisionHandler
                )
            )
        }
    }
}
