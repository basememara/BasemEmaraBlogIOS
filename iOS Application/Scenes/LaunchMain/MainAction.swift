//
//  MainAction.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//

import UIKit

enum MainAction: MainActionType {
    case loadMenu([MainAPI.Menu], UIUserInterfaceIdiom)
}

// MARK: - Logic

struct MainActionCreator: MainActionCreatorType {
    private let render: SceneRenderType
    private let dispatch: (MainAction) -> Void
    
    init(render: SceneRenderType, dispatch: @escaping (MainAction) -> Void) {
        self.render = render
        self.dispatch = dispatch
    }
}

extension MainActionCreator {

    func fetchMenu(with request: MainAPI.FetchMenuRequest) {
        switch request.layout {
        case .pad:
            dispatch(
                .loadMenu(
                    [
                        MainAPI.Menu(
                            id: SceneRender.Menu.blog.rawValue,
                            title: "Blog",
                            imageName: "tab-megaphone",
                            prefersLargeTitles: nil,
                            scene: render.showBlog
                        ),
                        MainAPI.Menu(
                            id: SceneRender.Menu.favorites.rawValue,
                            title: "Favorites",
                            imageName: "tab-favorite",
                            prefersLargeTitles: true,
                            scene: render.listFavorites
                        ),
                        MainAPI.Menu(
                            id: SceneRender.Menu.search.rawValue,
                            title: "Search",
                            imageName: "tab-search",
                            prefersLargeTitles: true,
                            scene: render.searchPosts
                        ),
                        MainAPI.Menu(
                            id: SceneRender.Menu.more.rawValue,
                            title: "More",
                            imageName: "tab-more",
                            prefersLargeTitles: true,
                            scene: render.showMore
                        )
                    ],
                    request.layout
                )
            )
        default:
            dispatch(
                .loadMenu(
                    [
                        MainAPI.Menu(
                            id: SceneRender.Menu.home.rawValue,
                            title: "Home",
                            imageName: "tab-home",
                            prefersLargeTitles: nil,
                            scene: render.home
                        ),
                        MainAPI.Menu(
                            id: SceneRender.Menu.blog.rawValue,
                            title: "Blog",
                            imageName: "tab-megaphone",
                            prefersLargeTitles: nil,
                            scene: render.showBlog
                        ),
                        MainAPI.Menu(
                            id: SceneRender.Menu.favorites.rawValue,
                            title: "Favorites",
                            imageName: "tab-favorite",
                            prefersLargeTitles: true,
                            scene: render.listFavorites
                        ),
                        MainAPI.Menu(
                            id: SceneRender.Menu.search.rawValue,
                            title: "Search",
                            imageName: "tab-search",
                            prefersLargeTitles: true,
                            scene: render.searchPosts
                        ),
                        MainAPI.Menu(
                            id: SceneRender.Menu.more.rawValue,
                            title: "More",
                            imageName: "tab-more",
                            prefersLargeTitles: true,
                            scene: render.showMore
                        )
                    ],
                    request.layout
                )
            )
        }
    }
}
