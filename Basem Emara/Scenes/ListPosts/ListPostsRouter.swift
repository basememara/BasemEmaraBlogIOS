//
//  ListPostsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

struct ListPostsRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

extension ListPostsRouter: ListPostsRoutable {
    
    func showPost(for model: PostsDataViewModel) {
        show(storyboard: .showPost) { (controller: ShowPostViewController) in
            controller.viewModel = model
        }
    }
}
