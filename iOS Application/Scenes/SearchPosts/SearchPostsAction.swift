//
//  SearchPostsAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct SearchPostsAction: SearchPostsActionable {
    private let presenter: SearchPostsPresentable
    private let postRepository: PostRepositoryType
    private let mediaRepository: MediaRepositoryType
    
    init(
        presenter: SearchPostsPresentable,
        postRepository: PostRepositoryType,
        mediaRepository: MediaRepositoryType
    ) {
        self.presenter = presenter
        self.postRepository = postRepository
        self.mediaRepository = mediaRepository
    }
}

extension SearchPostsAction {

    func fetchSearchResults(with request: PostAPI.SearchRequest) {
        postRepository.search(with: request) {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentSearchResults(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentSearchResults(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentSearchResults(
                    for: SearchPostsAPI.Response(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

extension SearchPostsAction {
    
    func fetchPopularPosts(with request: SearchPostsAPI.PopularRequest) {
        let request = PostAPI.FetchRequest()
        
        postRepository.fetchPopular(with: request) {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentSearchResults(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentSearchResults(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentSearchResults(
                    for: SearchPostsAPI.Response(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}
