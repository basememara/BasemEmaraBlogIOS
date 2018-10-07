//
//  SearchPostsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

struct SearchPostsRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

extension SearchPostsRouter: SearchPostsRoutable {

    func showPost(for model: PostsDataViewModel) {
        show(storyboard: .showPost) { (controller: ShowPostViewController) in
            controller.postID = model.id
        }
    }
}


