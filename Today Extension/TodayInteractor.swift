//
//  TodayInteractor.swift
//  Today Extension
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct TodayInteractor: TodayBusinessLogic, HasDependencies {
    private let presenter: TodayPresentable
    private let postWorker: PostWorkerType
    private let mediaWorker: MediaWorkerType
    
    init(presenter: TodayPresentable,
         postWorker: PostWorkerType,
         mediaWorker: MediaWorkerType) {
        self.presenter = presenter
        self.postWorker = postWorker
        self.mediaWorker = mediaWorker
    }
}

extension TodayInteractor {
    
    func fetchLatestPosts(with request: TodayModels.Request) {
        postWorker.fetch {
            guard case .success(let value) = $0 else {
                return self.presenter.presentLatestPosts(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            let posts = value.prefix(request.count).array
            
            self.mediaWorker.fetch(ids: Set(posts.compactMap { $0.mediaID })) {
                guard case .success(let media) = $0 else {
                    return self.presenter.presentLatestPosts(
                        error: $0.error ?? .unknownReason(nil)
                    )
                }
                
                self.presenter.presentLatestPosts(
                    for: TodayModels.Response(
                        posts: posts,
                        media: media
                    )
                )
            }
        }
    }
}

