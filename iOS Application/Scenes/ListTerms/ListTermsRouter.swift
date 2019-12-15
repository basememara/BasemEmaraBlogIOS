//
//  ListTermsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

struct ListTermsRouter: ListTermsRouterable {
    private let render: SceneRenderType
    weak var viewController: UIViewController?
    
    init(render: SceneRenderType, viewController: UIViewController?) {
        self.render = render
        self.viewController = viewController
    }
}

extension ListTermsRouter {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = render.listPosts(params: params)
        viewController?.show(controller)
    }
}
