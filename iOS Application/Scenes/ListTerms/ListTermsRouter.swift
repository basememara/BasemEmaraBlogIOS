//
//  ListTermsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

struct ListTermsRouter: ListTermsRoutable {
    weak var viewController: UIViewController?
    private let scenes: SceneModuleType
    
    init(viewController: UIViewController?, scenes: SceneModuleType) {
        self.viewController = viewController
        self.scenes = scenes
    }
}

extension ListTermsRouter {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = scenes.listPosts(params: params)
        viewController?.show(controller)
    }
}
