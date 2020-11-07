//
//  ShowBlogInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamCore

struct ShowBlogInteractor: ShowBlogInteractable {
    private let presenter: ShowBlogPresentable
    private let postRepository: PostRepository
    private let mediaRepository: MediaRepository
    private let taxonomyRepository: TaxonomyRepository
    private let favoriteRepository: FavoriteRepository
    private let preferences: Preferences

    init(
        presenter: ShowBlogPresentable,
        postRepository: PostRepository,
        mediaRepository: MediaRepository,
        taxonomyRepository: TaxonomyRepository,
        favoriteRepository: FavoriteRepository,
        preferences: Preferences
    ) {
        self.presenter = presenter
        self.postRepository = postRepository
        self.mediaRepository = mediaRepository
        self.taxonomyRepository = taxonomyRepository
        self.favoriteRepository = favoriteRepository
        self.preferences = preferences
    }
}

extension ShowBlogInteractor {
    
    func fetchLatestPosts(with request: ShowBlogAPI.FetchPostsRequest) {
        let request = PostAPI.FetchRequest(maxLength: request.maxLength)
        
        postRepository.fetch(with: request) {
            guard case .success(let posts) = $0 else {
                return presenter.displayLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return presenter.displayLatestPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                presenter.displayLatestPosts(
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

extension ShowBlogInteractor {
    
    func fetchPopularPosts(with request: ShowBlogAPI.FetchPostsRequest) {
        let request = PostAPI.FetchRequest(maxLength: request.maxLength)
        
        postRepository.fetchPopular(with: request) {
            guard case .success(let posts) = $0 else {
                return presenter.displayPopularPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return presenter.displayPopularPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                presenter.displayPopularPosts(
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

extension ShowBlogInteractor {
    
    func fetchTopPickPosts(with request: ShowBlogAPI.FetchPostsRequest) {
        let request = PostAPI.FetchRequest(maxLength: request.maxLength)
        
        postRepository.fetchTopPicks(with: request) {
            guard case .success(let posts) = $0 else {
                presenter.displayTopPickPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
                
                return
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    presenter.displayTopPickPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                    
                    return
                }
                
                presenter.displayTopPickPosts(
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

extension ShowBlogInteractor {
    
    func fetchTerms(with request: ShowBlogAPI.FetchTermsRequest) {
        taxonomyRepository.fetch(by: [.category, .tag]) {
            guard case .success(let items) = $0 else {
                presenter.displayTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
                
                return
            }
            
            let terms = items
                .sorted { $0.count > $1.count }
                .prefix(request.maxLength)
                .array
            
            presenter.displayTerms(
                for: ShowBlogAPI.TermsResponse(
                    terms: terms
                )
            )
        }
    }
}

extension ShowBlogInteractor {
    
    func toggleFavorite(with request: ShowBlogAPI.FavoriteRequest) {
        favoriteRepository.toggle(id: request.postID)
        
        presenter.displayToggleFavorite(
            for: ShowBlogAPI.FavoriteResponse(
                postID: request.postID,
                favorite: favoriteRepository.contains(id: request.postID)
            )
        )
    }
}
