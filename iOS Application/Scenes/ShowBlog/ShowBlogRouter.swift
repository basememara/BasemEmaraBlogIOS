//
//  ShowBlogRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct ShowBlogRouter: ShowBlogRoutable {
    weak var viewController: UIViewController?
    private let scenes: SceneRenderType
    
    init(viewController: UIViewController?, scenes: SceneRenderType) {
        self.viewController = viewController
        self.scenes = scenes
    }
}

extension ShowBlogRouter {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = scenes.listPosts(params: params)
        viewController?.show(controller)
    }
    
    func showPost(for model: PostsDataViewModel) {
        showPost(for: model.id)
    }
    
    func showPost(for id: Int) {
        let controller = scenes.showPost(for: id)
        viewController?.show(controller)
    }
    
    func listTerms() {
        let controller = scenes.listTerms()
        viewController?.show(controller)
    }
}
