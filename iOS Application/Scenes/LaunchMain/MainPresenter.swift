//
//  MainPresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//

import UIKit.UIViewController

struct MainPresenter: MainPresenterType {
    private let render: SceneRenderType
    
    init(render: SceneRenderType) {
        self.render = render
    }
}

extension MainPresenter {
    
    func fetchMenu(for idiom: UIUserInterfaceIdiom) -> [MainAPI.TabItem] {
        var menu = [
            MainAPI.TabItem(
                type: .blog,
                title: "Blog", // TODO: Localize
                imageName: "tab-megaphone",
                view: render.showBlog
            ),
            MainAPI.TabItem(
                type: .favorites,
                title: "Favorites",
                imageName: "tab-favorite",
                view: render.listFavorites
            ),
            MainAPI.TabItem(
                type: .search,
                title: "Search",
                imageName: "tab-search",
                view: render.searchPosts
            ),
            MainAPI.TabItem(
                type: .more,
                title: "More",
                imageName: "tab-more",
                view: render.showMore
            )
        ]
        
        if case .phone = idiom {
            menu.prepend(
                MainAPI.TabItem(
                    type: .home,
                    title: "Home",
                    imageName: "tab-home",
                    view: render.home
                )
            )
        }
        
        return menu
    }
    
    func showPost(for id: Int) -> UIViewController {
        render.showPost(for: id)
    }
}
