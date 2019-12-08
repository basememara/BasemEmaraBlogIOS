//
//  ShowPostRender.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

struct ShowPostRender: ShowPostRenderable {
    private let render: SceneRenderType
    
    weak var viewController: UIViewController?
    weak var listPostsDelegate: ListPostsDelegate?
    
    init(
        render: SceneRenderType,
        viewController: UIViewController?,
        listPostsDelegate: ListPostsDelegate?
    ) {
        self.render = render
        self.viewController = viewController
        self.listPostsDelegate = listPostsDelegate
    }
}

extension ShowPostRender {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = render.listPosts(
            params: params,
            delegate: listPostsDelegate
        )
        
        viewController?.show(controller)
    }
}
