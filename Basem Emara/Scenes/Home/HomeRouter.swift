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
        show(storyboard: .listPosts) { (controller: ListPostsViewController) in
            controller.fetchType = fetchType
        }
        }
    }
    
    func listTerms() {
        show(storyboard: .listTerms)
    }
}
