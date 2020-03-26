//
//  ShowPostAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ShowPostAction: ShowPostActionable {
    private let presenter: ShowPostPresentable
    private let postRepository: PostRepositoryType
    private let mediaRepository: MediaRepositoryType
    private let authorRepository: AuthorRepositoryType
    private let taxonomyRepository: TaxonomyRepositoryType
    
    init(
        presenter: ShowPostPresentable,
        postRepository: PostRepositoryType,
        mediaRepository: MediaRepositoryType,
        authorRepository: AuthorRepositoryType,
        taxonomyRepository: TaxonomyRepositoryType
    ) {
        self.presenter = presenter
        self.postRepository = postRepository
        self.mediaRepository = mediaRepository
        self.authorRepository = authorRepository
        self.taxonomyRepository = taxonomyRepository
    }
}

extension ShowPostAction {
    
    func fetchPost(with request: ShowPostAPI.Request) {
        postRepository.fetch(id: request.postID) {
            guard case .success(let value) = $0 else {
                return self.presenter.presentPost(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.presenter.presentPost(
                for: ShowPostAPI.Response(
                    post: value.post,
                    media: value.media,
                    categories: value.terms.filter { $0.taxonomy == .category },
                    tags: value.terms.filter { $0.taxonomy == .tag },
                    author: value.author,
                    favorite: self.postRepository.hasFavorite(id: value.post.id)
                )
            )
        }
    }
}

extension ShowPostAction {
    
    func fetchByURL(with request: ShowPostAPI.FetchWebRequest) {
        postRepository.fetch(url: request.url) {
            // Handle if URL is not for a post
            if case .nonExistent? = $0.error {
                self.taxonomyRepository.fetch(url: request.url) {
                    guard case .success(let term) = $0 else {
                        // URL could not be found
                        return self.presenter.presentByURL(
                            for: ShowPostAPI.FetchWebResponse(
                                post: nil,
                                term: nil,
                                decisionHandler: request.decisionHandler
                            )
                        )
                    }
                    
                    // URL was a taxonomy term
                    self.presenter.presentByURL(
                        for: ShowPostAPI.FetchWebResponse(
                            post: nil,
                            term: term,
                            decisionHandler: request.decisionHandler
                        )
                    )
                }
                
                return
            }
            
            guard case .success(let post) = $0 else {
                // URL could not be found
                return self.presenter.presentByURL(
                    for: ShowPostAPI.FetchWebResponse(
                        post: nil,
                        term: nil,
                        decisionHandler: request.decisionHandler
                    )
                )
            }
            
            // URL was a post
            self.presenter.presentByURL(
                for: ShowPostAPI.FetchWebResponse(
                    post: post,
                    term: nil,
                    decisionHandler: request.decisionHandler
                )
            )
        }
    }
}

extension ShowPostAction {
    
    func toggleFavorite(with request: ShowPostAPI.FavoriteRequest) {
        postRepository.toggleFavorite(id: request.postID)
        
        presenter.presentToggleFavorite(
            for: ShowPostAPI.FavoriteResponse(
                favorite: postRepository.hasFavorite(id: request.postID)
            )
        )
    }
}
