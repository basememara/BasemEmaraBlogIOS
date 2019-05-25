//
//  ListTermsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

struct ListTermsRouter: HasScenes {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ListTermsRouter: ListTermsRoutable {
    
    func listPosts(params: ListPostsModels.Params) {
        let controller = scenes.listPosts(params: params)
        viewController?.show(controller)
    }
}
