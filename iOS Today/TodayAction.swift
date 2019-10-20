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
    private let postWorker: PostWorkerType
    private let mediaWorker: MediaWorkerType
    
    init(
        presenter: TodayPresentable,
        postWorker: PostWorkerType,
        mediaWorker: MediaWorkerType
    ) {
        self.presenter = presenter
        self.postWorker = postWorker
        self.mediaWorker = mediaWorker
    }
}

extension TodayAction {
    
    func fetchLatestPosts(with request: TodayAPI.Request) {
        let request = PostsAPI.FetchRequest(maxLength: request.maxLength)
        
        postWorker.fetch(with: request) {
            guard case .success(let posts) = $0 else {
                return self.presenter.presentLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
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
