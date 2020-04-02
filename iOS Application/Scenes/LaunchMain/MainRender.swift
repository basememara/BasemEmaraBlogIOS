//
//  MainSplitRouter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-08.
//

import UIKit.UIViewController

struct MainRender: MainRenderType {
    private let render: SceneRenderType
    
    init(render: SceneRenderType) {
        self.render = render
    }
}

extension MainRender {
    
    func home() -> UIViewController {
        render.home()
    }
    
    func showBlog() -> UIViewController {
        render.showBlog()
    }
    
    func listFavorites() -> UIViewController {
        render.listFavorites()
    }
    
    func searchPosts() -> UIViewController {
        render.searchPosts()
    }
    
    func showMore() -> UIViewController {
        render.showMore()
    }
    
    func showPost(for id: Int) -> UIViewController {
        render.showPost(for: id)
    }
}
