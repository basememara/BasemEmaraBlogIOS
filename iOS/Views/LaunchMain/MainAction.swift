//
//  MainAction.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIDevice
import UIKit.UIImage

struct MainAction: MainActionable {
    private let presenter: MainPresentable
    
    init(presenter: MainPresentable) {
        self.presenter = presenter
    }
}

extension MainAction {
    
    func fetchMenu(for idiom: UIUserInterfaceIdiom) {
        var menu: [MainAPI.TabItem] = [
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
        
        if case .phone = idiom {
            menu.prepend(
                MainAPI.TabItem(
                    id: .home,
                    title: .localized(.tabHomeTitle),
                    imageName: UIImage.ImageName.tabHome.rawValue
                )
            )
        }
        
        presenter.display(menu: menu)
    }
}
