//
//  MainReducer.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//

struct MainReducer: MainReducerType {
    private let render: MainRenderType
    
    init(render: MainRenderType) {
        self.render = render
    }
}

extension MainReducer {
    
    func callAsFunction(_ state: inout MainState, _ action: MainAction) {
        switch action {
        case .fetchMenu(let idiom):
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
            
            state.tabMenu = menu
        }
    }
}
