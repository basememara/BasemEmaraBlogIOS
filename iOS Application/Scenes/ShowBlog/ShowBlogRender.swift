//
//  ShowBlogRender.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct ShowBlogRender: ShowBlogRenderable {
    private let render: SceneRenderType
    weak var viewController: UIViewController?
    
    init(render: SceneRenderType, viewController: UIViewController?) {
        self.viewController = viewController
        self.render = render
    }
}

extension ShowBlogRender {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = render.listPosts(params: params)
        viewController?.show(controller)
    }
    
    func showPost(for model: PostsDataViewModel) {
        showPost(for: model.id)
    }
    
    func showPost(for id: Int) {
        let controller = render.showPost(for: id)
        viewController?.show(controller)
    }
    
    func listTerms() {
        let controller = render.listTerms()
        viewController?.show(controller)
    }
}
