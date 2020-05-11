//
//  SearchPostsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol SearchPostsInteractable: Interactor {
    func fetchSearchResults(with request: PostAPI.SearchRequest)
    func fetchPopularPosts(with request: SearchPostsAPI.PopularRequest)
}

protocol SearchPostsPresenterType: Presenter {
    func displaySearchResults(for response: SearchPostsAPI.Response)
    func displaySearchResults(error: SwiftyPressError)
}

protocol SearchPostsRenderType: Render {
    func showPost(for model: PostsDataViewModel)
}

// MARK: - Namespace

enum SearchPostsAPI {
    
    struct PopularRequest {}
    
    struct Response {
        let posts: [PostType]
        let media: [MediaType]
    }
}
