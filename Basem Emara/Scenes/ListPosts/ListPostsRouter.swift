//
//  ListPostsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct ListPostsRouter: HasScenes {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ListPostsRouter: ListPostsRoutable {
    
    func showPost(for model: PostsDataViewModel) {
        let controller = scenes.showPost(for: model.id)
        viewController?.show(controller)
    }
    
    func previewPost(for model: PostsDataViewModel) -> UIViewController? {
        return scenes.previewPost(for: model, delegate: viewController)
    }
}
