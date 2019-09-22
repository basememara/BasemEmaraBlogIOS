//
//  ShowPostModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress

struct ShowPostModule: ShowPostModuleType {
    
    func resolve(with viewController: ShowPostDisplayable?) -> ShowPostActionable {
        ShowPostAction(
            presenter: resolve(with: viewController),
            postWorker: resolve(),
            mediaWorker: resolve(),
            authorWorker: resolve(),
            taxonomyWorker: resolve()
        )
    }
    
    func resolve(with viewController: ShowPostDisplayable?) -> ShowPostPresentable {
        ShowPostPresenter(
            viewController: viewController,
            constants: resolve()
        )
    }
    
    func resolve(with inputs: ShowPostAPI.RoutableInputs) -> ShowPostRoutable {
        ShowPostRouter(
            viewController: inputs.viewController,
            listPostsDelegate: inputs.listPostsDelegate,
            scenes: resolve()
        )
    }
}

extension ShowPostModule: Module {
    
    func register() {
        make { self as ShowPostModuleType }
    }
}
