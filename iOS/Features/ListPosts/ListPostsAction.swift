//
//  ListPostsAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListPostsAction: ListPostsActionable {
    private let presenter: ListPostsPresentable
    private let postRepository: PostRepository
    private let mediaRepository: MediaRepository
    private let favoriteRepository: FavoriteRepository
    
    init(
        presenter: ListPostsPresentable,
        postRepository: PostRepository,
        mediaRepository: MediaRepository,
        favoriteRepository: FavoriteRepository
    ) {
        self.presenter = presenter
        self.postRepository = postRepository
        self.mediaRepository = mediaRepository
        self.favoriteRepository = favoriteRepository
    }
}

extension ListPostsAction {
    
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
                
                self.favoriteRepository.fetchIDs {
                    guard case .success(let favoriteIDs) = $0 else {
                        self.presenter.displayPopularPosts(
                            error: $0.error ?? .unknownReason(nil)
                        )
                        
                        return
                    }
                    
                    self.presenter.displayPosts(
                        for: ListPostsAPI.PostsResponse(
                            posts: posts,
                            media: media,
                            favoriteIDs: favoriteIDs
                        )
                    )
                }
            }
        }
    }
}

extension ListPostsAction {
    
    func fetchPopularPosts(with request: ListPostsAPI.FetchPostsRequest) {
        let fetchRequest = PostAPI.FetchRequest()
        
        postRepository.fetchPopular(with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                self.presenter.displayPopularPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
                
                return
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    self.presenter.displayPopularPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                    
                    return
                }
                
                self.favoriteRepository.fetchIDs {
                    guard case .success(let favoriteIDs) = $0 else {
                        self.presenter.displayPopularPosts(
                            error: $0.error ?? .unknownReason(nil)
                        )
                        
                        return
                    }
                
                    self.presenter.displayPosts(
                        for: ListPostsAPI.PostsResponse(
                            posts: posts,
                            media: media,
                            favoriteIDs: favoriteIDs
                        )
                    )
                }
            }
        }
    }
}

extension ListPostsAction {
    
    func fetchTopPickPosts(with request: ListPostsAPI.FetchPostsRequest) {
        let fetchRequest = PostAPI.FetchRequest()
        
        postRepository.fetchTopPicks(with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                self.presenter.displayTopPickPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
                
                return
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    self.presenter.displayTopPickPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                    
                    return
                }
                
                self.favoriteRepository.fetchIDs {
                    guard case .success(let favoriteIDs) = $0 else {
                        self.presenter.displayPopularPosts(
                            error: $0.error ?? .unknownReason(nil)
                        )
                        
                        return
                    }
                    
                    self.presenter.displayPosts(
                        for: ListPostsAPI.PostsResponse(
                            posts: posts,
                            media: media,
                            favoriteIDs: favoriteIDs
                        )
                    )
                }
            }
        }
    }
}

extension ListPostsAction {
    
    func fetchPostsByTerms(with request: ListPostsAPI.FetchPostsByTermsRequest) {
        let fetchRequest = PostAPI.FetchRequest()
        
        postRepository.fetch(byTermIDs: request.ids, with: fetchRequest) {
            guard case .success(var posts) = $0 else {
                self.presenter.displayPostsByTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
                
                return
            }
            
            if let sort = request.sort {
                posts = posts.sorted(by: sort)
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    self.presenter.displayPostsByTerms(
                        error: $0.error ?? .unknownReason(nil)
                    )
                    
                    return
                }
                
                self.favoriteRepository.fetchIDs {
                    guard case .success(let favoriteIDs) = $0 else {
                        self.presenter.displayPopularPosts(
                            error: $0.error ?? .unknownReason(nil)
                        )
                        
                        return
                    }
                    
                    self.presenter.displayPosts(
                        for: ListPostsAPI.PostsResponse(
                            posts: posts,
                            media: media,
                            favoriteIDs: favoriteIDs
                        )
                    )
                }
            }
        }
    }
}

extension ListPostsAction {
    
    func toggleFavorite(with request: ListPostsAPI.FavoriteRequest) {
        favoriteRepository.toggle(id: request.postID)
        
        presenter.displayToggleFavorite(
            for: ListPostsAPI.FavoriteResponse(
                postID: request.postID,
                favorite: favoriteRepository.contains(id: request.postID)
            )
        )
    }
}
