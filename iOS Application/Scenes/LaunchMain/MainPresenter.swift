//
//  MainPresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//

import UIKit.UIViewController

class MainPresenter: MainPresenterType {
    private let render: SceneRenderType
    private let display: Input<MainState>
    
    init(render: SceneRenderType, display: @escaping Input<MainState>) {
        self.render = render
        self.display = display
    }
}

extension MainPresenter {
    
    func load(menu: [MainAPI.Menu]) {
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
        
        display(.loadMenu(menu))
    }
}

extension MainPresenter {
    
    func showPost(for id: Int) -> UIViewController {
        render.showPost(for: id)
    }
}
