//
//  ShowPostAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ShowPostInteractor: ShowPostInteractable {
    private let presenter: ShowPostPresentable
    private let postRepository: PostRepository
    private let mediaRepository: MediaRepository
    private let authorRepository: AuthorRepository
    private let taxonomyRepository: TaxonomyRepository
    private let favoriteRepository: FavoriteRepository
    
    init(
        presenter: ShowPostPresentable,
        postRepository: PostRepository,
        mediaRepository: MediaRepository,
        authorRepository: AuthorRepository,
        taxonomyRepository: TaxonomyRepository,
        favoriteRepository: FavoriteRepository
    ) {
        self.presenter = presenter
        self.postRepository = postRepository
        self.mediaRepository = mediaRepository
        self.authorRepository = authorRepository
        self.taxonomyRepository = taxonomyRepository
        self.favoriteRepository = favoriteRepository
    }
}

extension ShowPostInteractor {
    
    func fetchPost(with request: ShowPostAPI.Request) {
        postRepository.fetch(id: request.postID) {
            guard case .success(let item) = $0 else {
                self.presenter.displayPost(
                    error: $0.error ?? .unknownReason(nil)
                )
                
                return
            }
            
            self.presenter.displayPost(
                for: ShowPostAPI.Response(
                    post: item.post,
                    media: item.media,
                    categories: item.terms.filter { $0.taxonomy == .category },
                    tags: item.terms.filter { $0.taxonomy == .tag },
                    author: item.author,
                    favorite: self.favoriteRepository.contains(id: item.post.id)
                )
            )
        }
    }
}

extension ShowPostInteractor {
    
    func fetchByURL(with request: ShowPostAPI.FetchWebRequest) {
        postRepository.fetch(url: request.url) {
            // Handle if URL is not for a post
            if case .nonExistent? = $0.error {
                self.taxonomyRepository.fetch(url: request.url) {
                    guard case .success(let term) = $0 else {
                        // URL could not be found
                        return self.presenter.displayByURL(
                            for: ShowPostAPI.FetchWebResponse(
                                post: nil,
                                term: nil,
                                decisionHandler: request.decisionHandler
                            )
                        )
                    }
                    
                    // URL was a taxonomy term
                    self.presenter.displayByURL(
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
                return self.presenter.displayByURL(
                    for: ShowPostAPI.FetchWebResponse(
                        post: nil,
                        term: nil,
                        decisionHandler: request.decisionHandler
                    )
                )
            }
            
            // URL was a post
            self.presenter.displayByURL(
                for: ShowPostAPI.FetchWebResponse(
                    post: post,
                    term: nil,
                    decisionHandler: request.decisionHandler
                )
            )
        }
    }
}

extension ShowPostInteractor {
    
    func toggleFavorite(with request: ShowPostAPI.FavoriteRequest) {
        favoriteRepository.toggle(id: request.postID)
        
        presenter.displayToggleFavorite(
            for: ShowPostAPI.FavoriteResponse(
                favorite: favoriteRepository.contains(id: request.postID)
            )
        )
    }
}
