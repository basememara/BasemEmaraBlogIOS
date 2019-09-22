//
//  ListPostsModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress

struct ListPostsModule: ListPostsModuleType {
    
    func resolve(with viewController: ListPostsDisplayable?) -> ListPostsActionable {
        ListPostsAction(
            presenter: resolve(with: viewController),
            postWorker: resolve(),
            mediaWorker: resolve()
        )
    }
    
    func resolve(with viewController: ListPostsDisplayable?) -> ListPostsPresentable {
        ListPostsPresenter(viewController: viewController)
    }
    
    func resolve(with viewController: UIViewController?) -> ListPostsRoutable {
        ListPostsRouter(
            viewController: viewController,
            scenes: resolve()
        )
    }
}

extension ListPostsModule: Module {
    
    func register() {
        make { self as ListPostsModuleType }
    }
}
