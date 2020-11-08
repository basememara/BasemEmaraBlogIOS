//
//  MainModel+Preview.swift
//  iOS
//
//  Created by Basem Emara on 2020-11-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIImage

extension MainModel {
    
    static let preview = MainModel().apply {
        $0.tabMenu = [
            MainAPI.TabItem(
                id: .home,
                title: .localized(.tabHomeTitle),
                imageName: UIImage.ImageName.tabHome.rawValue
            ),
            MainAPI.TabItem(
                id: .blog,
                title: .localized(.tabBlogTitle),
                imageName: UIImage.ImageName.tabBlog.rawValue
            ),
            MainAPI.TabItem(
                id: .favorites,
                title: .localized(.tabFavoritesTitle),
                imageName: UIImage.ImageName.tabFavorite.rawValue
            ),
            MainAPI.TabItem(
                id: .search,
                title: .localized(.tabSearchTitle),
                imageName: UIImage.ImageName.tabSearch.rawValue
            ),
            MainAPI.TabItem(
                id: .more,
                title: .localized(.tabMoreTitle),
                imageName: UIImage.ImageName.tabMore.rawValue
            )
        ]
    }
}
