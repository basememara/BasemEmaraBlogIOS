//
//  SearchPostsModel+Preview.swift
//  iOS
//
//  Created by Basem Emara on 2020-11-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

extension SearchPostsModel {
    
    static let preview = SearchPostsModel().apply {
        $0.posts = AppPreviews.shared.store.allPosts?.values.shuffled().prefix(10).array
    }
}
