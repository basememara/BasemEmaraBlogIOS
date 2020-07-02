//
//  MainRendter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIViewController

struct MainRender: MainRenderable {
    private let render: RenderDelegate
    
    init(render: RenderDelegate) {
        self.render = render
    }
}

extension MainRender {
    
    func rootView(for menu: MainAPI.Menu) -> UIViewController {
        switch menu {
        case .home:
            return render.home()
        case .blog:
            return render.showBlog()
        case .favorites:
            return render.listFavorites()
        case .search:
            return render.searchPosts()
        case .more:
            return render.showMore()
        }
    }
}

extension MainRender {
    
    func postView(for id: Int) -> UIViewController {
        render.showPost(for: id)
    }
}
