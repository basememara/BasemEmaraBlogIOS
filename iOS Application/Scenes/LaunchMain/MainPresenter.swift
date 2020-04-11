//
//  MainPresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIViewController

class MainPresenter: MainPresenterType {
    private let render: SceneRenderType
    private let send: Action<MainState>
    
    init(render: SceneRenderType, send: @escaping Action<MainState>) {
        self.render = render
        self.send = send
    }
}

extension MainPresenter {
    
    func display(menu: [MainAPI.Menu]) {
        let menu: [MainAPI.TabItem] = menu.map {
            switch $0 {
            case .blog:
                return MainAPI.TabItem(
                    type: .blog,
                    title: "Blog", // TODO: Localize
                    imageName: "tab-megaphone",
                    view: render.showBlog
                )
            case .favorites:
                return MainAPI.TabItem(
                    type: .favorites,
                    title: "Favorites",
                    imageName: "tab-favorite",
                    view: render.listFavorites
                )
            case .search:
                return MainAPI.TabItem(
                    type: .search,
                    title: "Search",
                    imageName: "tab-search",
                    view: render.searchPosts
                )
            case .more:
                return MainAPI.TabItem(
                    type: .more,
                    title: "More",
                    imageName: "tab-more",
                    view: render.showMore
                )
            case .home:
                return MainAPI.TabItem(
                    type: .home,
                    title: "Home",
                    imageName: "tab-home",
                    view: render.home
                )
            }
        }
        
        send(.loadMenu(menu))
    }
}

extension MainPresenter {
    
    func displayPost(for id: Int) -> UIViewController {
        render.showPost(for: id)
    }
}
