//
//  ShowPostRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

struct ShowPostRouter: ShowPostRoutable {
    weak var viewController: UIViewController?
    weak var listPostsDelegate: ListPostsDelegate?
    
    private let scenes: SceneModuleType
    
    init(
        viewController: UIViewController?,
        listPostsDelegate: ListPostsDelegate?,
        scenes: SceneModuleType
    ) {
        self.viewController = viewController
        self.listPostsDelegate = listPostsDelegate
        self.scenes = scenes
    }
}

extension ShowPostRouter {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = scenes.listPosts(
            params: params,
            delegate: listPostsDelegate
        )
        
        viewController?.show(controller)
    }
}
