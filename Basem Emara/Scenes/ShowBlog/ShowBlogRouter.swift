//
//  ShowBlogRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct ShowBlogRouter {
    private let scenes: SceneModuleType
    weak var viewController: UIViewController?
    
    init(scenes: SceneModuleType, viewController: UIViewController?) {
        self.scenes = scenes
        self.viewController = viewController
    }
}

extension ShowBlogRouter: ShowBlogRoutable {
    
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
    
    func previewPost(for model: PostsDataViewModel) -> UIViewController? {
        return scenes.previewPost(for: model, delegate: viewController)
    }
    
    func listTerms() {
        let controller = scenes.listTerms()
        viewController?.show(controller)
    }
}
