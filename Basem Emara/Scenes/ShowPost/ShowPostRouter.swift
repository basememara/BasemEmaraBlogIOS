//
//  ShowPostRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

struct ShowPostRouter: HasScenes {
    weak var viewController: UIViewController?
    weak var listPostsDelegate: ListPostsDelegate?
    
    init(viewController: UIViewController, listPostsDelegate: ListPostsDelegate) {
        self.viewController = viewController
        self.listPostsDelegate = listPostsDelegate
    }
}

extension ShowPostRouter: ShowPostRoutable {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = scenes.listPosts(
            params: params,
            delegate: listPostsDelegate
        )
        
        viewController?.show(controller)
    }
}
