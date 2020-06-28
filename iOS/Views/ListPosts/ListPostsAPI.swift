//
//  ListPostsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit.UIViewController
import ZamzamUI

protocol ListPostsInteractable: Interactor {
    func fetchLatestPosts(with request: ListPostsAPI.FetchPostsRequest)
    func fetchPopularPosts(with request: ListPostsAPI.FetchPostsRequest)
    func fetchTopPickPosts(with request: ListPostsAPI.FetchPostsRequest)
    func fetchPostsByTerms(with request: ListPostsAPI.FetchPostsByTermsRequest)
    func toggleFavorite(with request: ListPostsAPI.FavoriteRequest)
}

protocol ListPostsPresentable: Presenter {
    func displayPosts(for response: ListPostsAPI.PostsResponse)
    
    func displayLatestPosts(error: SwiftyPressError)
    func displayPopularPosts(error: SwiftyPressError)
    func displayTopPickPosts(error: SwiftyPressError)
    func displayPostsByTerms(error: SwiftyPressError)
    
    func displayToggleFavorite(for response: ListPostsAPI.FavoriteResponse)
}

protocol ListPostsRenderable: Render {
    func showPost(for model: PostsDataViewModel)
}

protocol ListPostsDelegate: AnyObject {
    func listPosts(_ viewController: UIViewController, didSelect postID: Int)
}

// MARK: - Namespace

enum ListPostsAPI {
    
    enum FetchType {
        case latest
        case popular
        case picks
        case terms(Set<Int>)
    }
    
    struct Params {
        let fetchType: FetchType
        let title: String?
        let sort: ((Post, Post) -> Bool)?
        
        init(fetchType: FetchType, title: String? = nil, sort: ((Post, Post) -> Bool)? = nil) {
            self.fetchType = fetchType
            self.title = title
            self.sort = sort
        }
    }
}

extension ListPostsAPI {
    
    struct FetchPostsRequest {
        let sort: ((Post, Post) -> Bool)?
    }
    
    struct FetchPostsByTermsRequest {
        let ids: Set<Int>
        let sort: ((Post, Post) -> Bool)?
    }
    
    struct PostsResponse {
        let posts: [Post]
        let media: [Media]
        let favoriteIDs: [Int]
    }
}

extension ListPostsAPI {
    
    struct FavoriteRequest {
        let postID: Int
    }
    
    struct FavoriteResponse {
        let postID: Int
        let favorite: Bool
    }
    
    struct FavoriteViewModel {
        let postID: Int
        let favorite: Bool
    }
}
