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
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ShowPostRouter: ShowPostRoutable {
    
    func listPosts(for fetchType: ListPostsViewController.FetchType) {
        let controller = scenes.listPosts(
            for: fetchType,
            delegate: viewController as? ShowPostViewControllerDelegate
        )
        
        viewController?.show(controller)
    }
    
}
