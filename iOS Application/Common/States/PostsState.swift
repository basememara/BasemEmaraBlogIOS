//
//  PostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-05-31.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress
import ZamzamUI

class PostsState: StateRepresentable {
    
    private(set) var allPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != allPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != allPosts else { return }
            notificationPost(for: \Self.allPosts)
        }
    }
}

// MARK: - Action

enum PostsAction: Action {
    case mergePosts([PostsDataViewModel])
    case toggleFavorite(postID: Int, favorite: Bool)
}

// MARK: - Reducer

extension PostsState {
    
    func callAsFunction(_ action: PostsAction) {
        switch action {
        case .mergePosts(let items):
            let ids = items.map(\.id)
            allPosts = allPosts.filter { !ids.contains($0.id) } + items
        case .toggleFavorite(let postID, let favorite):
            guard let current = allPosts
                .first(where: { $0.id == postID })?
                .toggled(favorite: favorite) else {
                    return
            }
            
            self(.mergePosts([current]))
        }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension PostsState: ObservableObject {}
#endif
