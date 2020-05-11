//
//  ListPostsAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListPostsInteractor: ListPostsInteractable {
    private let presenter: ListPostsPresentable
    private let postRepository: PostRepository
    private let mediaRepository: MediaRepository
    
    init(
        presenter: ListPostsPresentable,
        postRepository: PostRepository,
        mediaRepository: MediaRepository
    ) {
        self.presenter = presenter
        self.postRepository = postRepository
        self.mediaRepository = mediaRepository
    }
}

extension ListPostsInteractor {
    
    func fetchLatestPosts(with request: ListPostsAPI.FetchPostsRequest) {
        let fetchRequest = PostAPI.FetchRequest()
        
        postRepository.fetch(with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                return self.presenter.displayLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.displayLatestPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.displayPosts(
                    for: ListPostsAPI.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func fetchPopularPosts(with request: ListPostsAPI.FetchPostsRequest) {
        let fetchRequest = PostAPI.FetchRequest()
        
        postRepository.fetchPopular(with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                return self.presenter.displayPopularPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.displayPopularPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.displayPosts(
                    for: ListPostsAPI.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func fetchTopPickPosts(with request: ListPostsAPI.FetchPostsRequest) {
        let fetchRequest = PostAPI.FetchRequest()
        
        postRepository.fetchTopPicks(with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                return self.presenter.displayTopPickPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.displayTopPickPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.displayPosts(
                    for: ListPostsAPI.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func fetchPostsByTerms(with request: ListPostsAPI.FetchPostsByTermsRequest) {
        let fetchRequest = PostAPI.FetchRequest()
        
        postRepository.fetch(byTermIDs: request.ids, with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                return self.presenter.displayPostsByTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.displayPostsByTerms(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.displayPosts(
                    for: ListPostsAPI.PostsResponse(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension ListPostsInteractor {
    
    func toggleFavorite(with request: ListPostsAPI.FavoriteRequest) {
        postRepository.toggleFavorite(id: request.postID)
        
        presenter.displayToggleFavorite(
            for: ListPostsAPI.FavoriteResponse(
                postID: request.postID,
                favorite: postRepository.hasFavorite(id: request.postID)
            )
        )
    }
    
    func isFavorite(postID: Int) -> Bool {
        postRepository.hasFavorite(id: postID)
    }
}
