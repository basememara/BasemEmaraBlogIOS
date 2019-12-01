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
    private let postProvider: PostProviderType
    private let mediaProvider: MediaProviderType
    
    init(
        presenter: TodayPresentable,
        postProvider: PostProviderType,
        mediaProvider: MediaProviderType
    ) {
        self.presenter = presenter
        self.postProvider = postProvider
        self.mediaProvider = mediaProvider
    }
}

extension TodayAction {
    
    func fetchLatestPosts(with request: TodayAPI.Request) {
        let request = PostAPI.FetchRequest(maxLength: request.maxLength)
        
        postProvider.fetch(with: request) {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaProvider.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentLatestPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentLatestPosts(
                    for: TodayAPI.Response(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}
