//
//  ListPostsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct ListPostsRouter: ListPostsRoutable {
    weak var viewController: UIViewController?
    private let scenes: SceneModuleType
    
    init(viewController: UIViewController?, scenes: SceneModuleType) {
        self.viewController = viewController
        self.scenes = scenes
    }
}

extension ListPostsRouter {
    
    func showPost(for model: PostsDataViewModel) {
        let controller = scenes.showPost(for: model.id)
        viewController?.show(controller)
    }
}
