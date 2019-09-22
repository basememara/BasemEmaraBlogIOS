//
//  SearchPostsModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress

struct SearchPostsModule: SearchPostsModuleType {
    
    func resolve(with viewController: SearchPostsDisplayable?) -> SearchPostsActionable {
        SearchPostsAction(
            presenter: resolve(with: viewController),
            postWorker: resolve(),
            mediaWorker: resolve()
        )
    }
    
    func resolve(with viewController: SearchPostsDisplayable?) -> SearchPostsPresentable {
        SearchPostsPresenter(viewController: viewController)
    }
    
    func resolve(with viewController: UIViewController?) -> SearchPostsRoutable {
        SearchPostsRouter(
            viewController: viewController,
            scenes: resolve()
        )
    }
}

extension SearchPostsModule: Module {
    
    func register() {
        make { self as SearchPostsModuleType }
    }
}
