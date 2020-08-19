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
    
    fileprivate(set) var allPosts: [Int: PostsDataViewModel] = [:] {
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

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension PostsState: ObservableObject {}
#endif

// MARK: - Reducer

enum PostsReducer: Reducer {
    case mergePosts([PostsDataViewModel])
    case toggleFavorite(postID: Int, favorite: Bool)
}

extension AppStore {
    
    func reduce(_ reducer: PostsReducer) {
        switch reducer {
        case .mergePosts(let items):
            postsState.allPosts.merge(items.map { ($0.id, $0) }) { $1 }
        case .toggleFavorite(let postID, let favorite):
            postsState.allPosts[postID] = postsState.allPosts[postID]?
                .toggled(favorite: favorite)
        }
    }
}
