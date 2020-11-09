//
//  ListFavoritesModel+Preview.swift
//  iOS
//
//  Created by Basem Emara on 2020-11-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

extension ListFavoritesModel {
    
    static let preview = ListFavoritesModel().apply {
        $0(\.favorites, AppPreviews.shared.store.allPosts?.values.shuffled().prefix(10).array)
    }
}
