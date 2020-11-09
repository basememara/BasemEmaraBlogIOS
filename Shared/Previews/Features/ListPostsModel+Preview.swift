//
//  ListPostsModel+Preview.swift
//  iOS
//
//  Created by Basem Emara on 2020-11-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

extension ListPostsModel {
    
    static let preview = ListPostsModel().apply {
        $0(\.posts, AppPreviews.shared.store.allPosts?.values.shuffled().prefix(10).array)
    }
}
