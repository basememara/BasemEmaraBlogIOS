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
    
    func display(menu: [MainAPI.TabItem]) {
        let menu: [MainAPI.TabMenu] = menu
            .reduce(into: [MainAPI.TabMenu]()) { result, next in
                let view: UIViewController
                
                switch next.id {
                case .home:
                    view = render.home()
                case .blog:
                    view = render.showBlog()
                case .favorites:
                    view = render.listFavorites()
                case .search:
                    view = render.searchPosts()
                case .more:
                    view = render.showMore()
                }
                
                let menu: MainAPI.TabMenu
                
                if #available(iOS 13, *) {
                    menu = MainAPI.TabMenu(
                        item: next,
                        view: ViewRepresentable(viewController: view)
                    )
                } else {
                    menu = MainAPI.TabMenu(
                        item: next,
                        view: view
                    )
                }
                
                result.append(menu)
            }
        
        send(.loadMenu(menu))
    }
}

extension MainPresenter {
    
    func displayPost(for id: Int) -> UIViewController {
        render.showPost(for: id)
    }
}
