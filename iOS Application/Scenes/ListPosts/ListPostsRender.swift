//
//  ListPostsRender.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct ListPostsRender: ListPostsRenderable {
    private let render: SceneRenderType
    weak var viewController: UIViewController?
    
    init(render: SceneRenderType, viewController: UIViewController?) {
        self.viewController = viewController
        self.render = render
    }
}

extension ListPostsRender {
    
    func showPost(for model: PostsDataViewModel) {
        let controller = render.showPost(for: model.id)
        viewController?.show(controller)
    }
}
