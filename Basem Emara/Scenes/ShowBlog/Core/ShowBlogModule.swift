//
//  ShowBlogModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress

struct ShowBlogModule: ShowBlogModuleType {
    
    func resolve(with viewController: ShowBlogDisplayable?) -> ShowBlogActionable {
        ShowBlogAction(
            presenter: resolve(with: viewController),
            postWorker: resolve(),
            mediaWorker: resolve(),
            taxonomyWorker: resolve(),
            preferences: resolve()
        )
    }
    
    func resolve(with viewController: ShowBlogDisplayable?) -> ShowBlogPresentable {
        ShowBlogPresenter(viewController: viewController)
    }
    
    func resolve(with viewController: UIViewController?) -> ShowBlogRoutable {
        ShowBlogRouter(
            viewController: viewController,
            scenes: resolve()
        )
    }
}

extension ShowBlogModule: Module {
    
    func register() {
        make { self as ShowBlogModuleType }
    }
}
