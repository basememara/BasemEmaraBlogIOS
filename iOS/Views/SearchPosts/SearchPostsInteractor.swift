//
//  SearchPostsAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct SearchPostsInteractor: SearchPostsInteractable {
    private let presenter: SearchPostsPresentable
    private let postRepository: PostRepository
    private let mediaRepository: MediaRepository
    private let favoriteRepository: FavoriteRepository
    
    init(
        presenter: SearchPostsPresentable,
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

extension SearchPostsInteractor {

    func fetchSearchResults(with request: PostAPI.SearchRequest) {
        postRepository.search(with: request) {
            guard case .success(let posts) = $0 else {
                return self.presenter.displaySearchResults(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.displaySearchResults(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.favoriteRepository.fetchIDs {
                    guard case .success(let favoriteIDs) = $0 else {
                        self.presenter.displaySearchResults(
                            error: $0.error ?? .unknownReason(nil)
                        )
                        
                        return
                    }
                    
                    self.presenter.displaySearchResults(
                        for: SearchPostsAPI.Response(
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

extension SearchPostsInteractor {
    
    func fetchPopularPosts(with request: SearchPostsAPI.PopularRequest) {
        let request = PostAPI.FetchRequest()
        
        postRepository.fetchPopular(with: request) {
            guard case .success(let posts) = $0 else {
                return self.presenter.displaySearchResults(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.displaySearchResults(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.favoriteRepository.fetchIDs {
                    guard case .success(let favoriteIDs) = $0 else {
                        self.presenter.displaySearchResults(
                            error: $0.error ?? .unknownReason(nil)
                        )
                        
                        return
                    }
                    
                    self.presenter.displaySearchResults(
                        for: SearchPostsAPI.Response(
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
