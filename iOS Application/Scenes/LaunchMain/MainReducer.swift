//
//  MainReducer.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//

struct MainReducer: ReducerType {
    private let render: SceneRenderType
    
    init(render: SceneRenderType) {
        self.render = render
    }
}

extension MainReducer {
    
    func reduce(_ state: AppState, _ action: MainAction) {
        switch action {
        case .loadMenu(let items, let layout):
            state.main = MainModel(
                menu: items.map { menu in
                    switch menu {
                    case .home:
                        return MainAPI.Menu(
                            id: menu.rawValue,
                            title: "Home", // TODO: Localize
                            imageName: "tab-home",
                            prefersLargeTitles: nil,
                            scene: render.home
                        )
                    case .blog:
                        return MainAPI.Menu(
                            id: menu.rawValue,
                            title: "Blog",
                            imageName: "tab-megaphone",
                            prefersLargeTitles: nil,
                            scene: render.showBlog
                        )
                    case .favorites:
                        return MainAPI.Menu(
                            id: menu.rawValue,
                            title: "Favorites",
                            imageName: "tab-favorite",
                            prefersLargeTitles: true,
                            scene: render.listFavorites
                        )
                    case .search:
                        return MainAPI.Menu(
                            id: menu.rawValue,
                            title: "Search",
                            imageName: "tab-search",
                            prefersLargeTitles: true,
                            scene: render.searchPosts
                        )
                    case .more:
                        return MainAPI.Menu(
                            id: menu.rawValue,
                            title: "More",
                            imageName: "tab-more",
                            prefersLargeTitles: true,
                            scene: render.showMore
                        )
                    }
                },
                layout: layout
            )
        }
    }
}
