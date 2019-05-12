//
//  HomeRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct HomeRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension HomeRouter: HomeRoutable {
    
    func listPosts(for fetchType: ListPostsViewController.FetchType) {
        show(storyboard: .listPosts) { (controller: ListPostsViewController) in
            controller.fetchType = fetchType
        }
    }
    
    func showPost(for model: PostsDataViewModel) {
        showPost(for: model.id)
    }
    
    func showPost(for id: Int) {
        show(storyboard: .showPost) { (controller: ShowPostViewController) in
            controller.postID = id
        }
    }
    
    func previewPost(for model: PostsDataViewModel) -> UIViewController? {
        let storyboard = UIStoryboard(name: Storyboard.previewPost.rawValue)
        
        return (storyboard.instantiateInitialViewController() as? PreviewPostViewController)?.with {
            $0.viewModel = model
            $0.delegate = self.viewController
        }
    }
    
    func listTerms() {
        show(storyboard: .listTerms)
    }
}
