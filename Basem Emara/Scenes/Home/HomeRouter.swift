//
//  HomeRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

struct HomeRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

extension HomeRouter: HomeRoutable {
    
    func listPosts(for fetchType: ListPostsViewController.FetchType) {
        let storyboard = UIStoryboard(name: "ListPosts")
        
        guard let controller = storyboard.instantiateInitialViewController() as? ListPostsViewController else {
            return
        }
        
        controller.fetchType = .popular
        
        viewController?.show(controller, sender: nil)
    }
}
