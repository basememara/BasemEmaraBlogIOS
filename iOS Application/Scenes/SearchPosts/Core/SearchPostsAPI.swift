//
//  SearchPostsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI

// Scene namespace
enum SearchPostsAPI {}

protocol SearchPostsCoreType {
    func dependency(with viewController: SearchPostsDisplayable?) -> SearchPostsActionable
    func dependency(with viewController: SearchPostsDisplayable?) -> SearchPostsPresentable
    func dependency(with viewController: UIViewController?) -> SearchPostsRouterable
    
    func dependency() -> ConstantsType
    func dependency() -> Theme
}

protocol SearchPostsActionable: AppActionable {
    func fetchSearchResults(with request: PostAPI.SearchRequest)
    func fetchPopularPosts(with request: SearchPostsAPI.PopularRequest)
}

protocol SearchPostsPresentable: AppPresentable {
    func presentSearchResults(for response: SearchPostsAPI.Response)
    func presentSearchResults(error: DataError)
}

protocol SearchPostsDisplayable: class, AppDisplayable {
    func displayPosts(with viewModels: [PostsDataViewModel])
}

protocol SearchPostsRouterable {
    func showPost(for model: PostsDataViewModel)
}

// MARK: - Request/Response

extension SearchPostsAPI {
    
    struct PopularRequest {
        
    }
    
    struct Response {
        let posts: [PostType]
        let media: [MediaType]
    }
}
