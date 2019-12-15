//
//  ShowPostRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI

struct ShowPostRouter: ShowPostRouterable, AppRoutable {
    private let render: SceneRenderType
    private let theme: Theme
    
    weak var viewController: UIViewController?
    weak var listPostsDelegate: ListPostsDelegate?
    
    init(
        render: SceneRenderType,
        theme: Theme,
        viewController: UIViewController?,
        listPostsDelegate: ListPostsDelegate?
    ) {
        self.render = render
        self.theme = theme
        self.viewController = viewController
        self.listPostsDelegate = listPostsDelegate
    }
}

extension ShowPostRouter {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = render.listPosts(
            params: params,
            delegate: listPostsDelegate
        )
        
        viewController?.show(controller)
    }
}

extension ShowPostRouter {
    
    func show(url: String) {
        present(safari: url, theme: theme)
    }
}
