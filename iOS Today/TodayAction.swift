//
//  TodayAction.swift
//  Today Extension
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct TodayAction: TodayActionable {
    private let presenter: TodayPresentable
    private let postRepository: PostRepository
    private let mediaRepository: MediaRepository
    
    init(
        presenter: TodayPresentable,
        postRepository: PostRepository,
        mediaRepository: MediaRepository
    ) {
        self.presenter = presenter
        self.postRepository = postRepository
        self.mediaRepository = mediaRepository
    }
}

extension TodayAction {
    
    func fetchLatestPosts(with request: TodayAPI.Request) {
        let request = PostAPI.FetchRequest(maxLength: request.maxLength)
        
        postRepository.fetch(with: request) {
            guard case .success(let posts) = $0 else {
                self.presenter.displayLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
                
                return
            }
            
            self.mediaRepository.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    self.presenter.displayLatestPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                    
                    return
                }
                
                self.presenter.displayLatestPosts(
                    for: TodayAPI.Response(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}
