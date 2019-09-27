//
//  SearchPostsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct SearchPostsRouter: SearchPostsRoutable {
    weak var viewController: UIViewController?
    private let scenes: SceneModuleType
    
    init(viewController: UIViewController?, scenes: SceneModuleType) {
        self.viewController = viewController
        self.scenes = scenes
    }
}

extension SearchPostsRouter {

    func showPost(for model: PostsDataViewModel) {
        let controller = scenes.showPost(for: model.id)
        viewController?.show(controller)
    }
}
