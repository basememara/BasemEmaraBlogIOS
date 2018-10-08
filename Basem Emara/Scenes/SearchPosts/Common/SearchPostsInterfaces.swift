//
//  SearchPostsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol SearchPostsBusinessLogic {
    func fetchSearchResults(with request: PostsModels.SearchRequest)
    func fetchPopularPosts(with request: SearchPostsModels.PopularRequest)
}

protocol SearchPostsPresentable {
    func presentSearchResults(for response: SearchPostsModels.Response)
    func presentSearchResults(error: DataError)
}

protocol SearchPostsDisplayable: class, AppDisplayable {
    func displayPosts(with viewModels: [PostsDataViewModel])
}

protocol SearchPostsRoutable: AppRoutable {
    func showPost(for model: PostsDataViewModel)
}
