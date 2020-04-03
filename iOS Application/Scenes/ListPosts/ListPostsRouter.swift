//
//  ListPostsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct ListPostsRouter: ListPostsRouterable {
    private let render: SceneRenderType
    
    weak var viewController: UIViewController?
    weak var listPostsDelegate: ListPostsDelegate?
    
    init(
        render: SceneRenderType,
        viewController: UIViewController?,
        listPostsDelegate: ListPostsDelegate?
    ) {
        self.render = render
        self.viewController = viewController
        self.listPostsDelegate = listPostsDelegate
    }
}

extension ListPostsRouter {
    
    func showPost(for model: PostsDataViewModel) {
        guard let listPostsDelegate = listPostsDelegate,
            let viewController = viewController else {
                self.viewController?.show(
                    render.showPost(for: model.id)
                )
                
                return
        }
        
        listPostsDelegate.listPosts(viewController, didSelect: model.id)
    }
}
