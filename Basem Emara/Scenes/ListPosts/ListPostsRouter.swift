//
//  ListPostsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct ListPostsRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ListPostsRouter: ListPostsRoutable {
    
    func showPost(for model: PostsDataViewModel) {
        show(storyboard: .showPost) { (controller: ShowPostViewController) in
            controller.postID = model.id
        }
    }
    
    func previewPost(for model: PostsDataViewModel) -> UIViewController? {
        let storyboard = UIStoryboard(name: Storyboard.previewPost.rawValue)
        
        return (storyboard.instantiateInitialViewController() as? PreviewPostViewController)?.with {
            $0.viewModel = model
            $0.delegate = self.viewController
        }
    }
}
