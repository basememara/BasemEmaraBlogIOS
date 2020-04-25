//
//  ListPostsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit.UIViewController

protocol ListPostsInteractorType: InteractorType {
    func fetchLatestPosts(with request: ListPostsAPI.FetchPostsRequest)
    func fetchPopularPosts(with request: ListPostsAPI.FetchPostsRequest)
    func fetchTopPickPosts(with request: ListPostsAPI.FetchPostsRequest)
    func fetchPostsByTerms(with request: ListPostsAPI.FetchPostsByTermsRequest)
    func toggleFavorite(with request: ListPostsAPI.FavoriteRequest)
    func isFavorite(postID: Int) -> Bool
}

protocol ListPostsPresenterType: PresenterType {
    func displayPosts(for response: ListPostsAPI.PostsResponse)
    
    func displayLatestPosts(error: DataError)
    func displayPopularPosts(error: DataError)
    func displayTopPickPosts(error: DataError)
    func displayPostsByTerms(error: DataError)
    
    func displayToggleFavorite(for response: ListPostsAPI.FavoriteResponse)
}

protocol ListPostsRenderType: RenderType {
    func showPost(for model: PostsDataViewModel)
}

protocol ListPostsDelegate: class {
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
        let sort: ((PostType, PostType) -> Bool)?
        
        init(fetchType: FetchType, title: String? = nil, sort: ((PostType, PostType) -> Bool)? = nil) {
            self.fetchType = fetchType
            self.title = title
            self.sort = sort
        }
    }
}

extension ListPostsAPI {
    
    struct FetchPostsRequest {
        let sort: ((PostType, PostType) -> Bool)?
    }
    
    struct FetchPostsByTermsRequest {
        let ids: Set<Int>
        let sort: ((PostType, PostType) -> Bool)?
    }
    
    struct PostsResponse {
        let posts: [PostType]
        let media: [MediaType]
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
