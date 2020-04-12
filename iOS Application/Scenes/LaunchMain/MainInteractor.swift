//
//  MainInteractor.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIDevice

struct MainInteractor: MainInteractorType {
    private let presenter: MainPresenterType
    
    init(presenter: MainPresenterType) {
        self.presenter = presenter
    }
}

extension MainInteractor {
    
    func fetchMenu(for idiom: UIUserInterfaceIdiom) {
        var menu: [MainAPI.TabItem] = [
            MainAPI.TabItem(
                id: .blog,
                title: "Blog", // TODO: Localize
                imageName: "tab-megaphone"
            ),
            MainAPI.TabItem(
                id: .favorites,
                title: "Favorites",
                imageName: "tab-favorite"
            ),
            MainAPI.TabItem(
                id: .search,
                title: "Search",
                imageName: "tab-search"
            ),
            MainAPI.TabItem(
                id: .more,
                title: "More",
                imageName: "tab-more"
            )
        ]
        
        if case .phone = idiom {
            menu.prepend(
                MainAPI.TabItem(
                    id: .home,
                    title: "Home",
                    imageName: "tab-home"
                )
            )
        }
        
        presenter.display(menu: menu)
    }
}
