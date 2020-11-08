//
//  ShowBlogModel+Preview.swift
//  iOS
//
//  Created by Basem Emara on 2020-11-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

extension ShowBlogModel {
    
    static let preview = ShowBlogModel().apply {
        $0.latestPosts = AppPreviews.shared.store.allPosts?.values.shuffled().prefix(10).array
        $0.popularPosts = AppPreviews.shared.store.allPosts?.values.shuffled().prefix(10).array
        $0.topPickPosts = AppPreviews.shared.store.allPosts?.values.shuffled().prefix(10).array
        $0.terms = AppPreviews.shared.store.allTerms?.values.shuffled().prefix(10).array
    }
}
