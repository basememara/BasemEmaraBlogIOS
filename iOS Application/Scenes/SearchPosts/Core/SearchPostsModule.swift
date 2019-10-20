//
//  SearchPostsModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct SearchPostsModule: SearchPostsModuleType {
    @Inject private var appModule: SwiftyPressModule
    @Inject private var sceneModule: SceneModuleType
    
    func component(with viewController: SearchPostsDisplayable?) -> SearchPostsActionable {
        SearchPostsAction(
            presenter: component(with: viewController),
            postWorker: appModule.component(),
            mediaWorker: appModule.component()
        )
    }
    
    func component(with viewController: SearchPostsDisplayable?) -> SearchPostsPresentable {
        SearchPostsPresenter(viewController: viewController)
    }
    
    func component(with viewController: UIViewController?) -> SearchPostsRoutable {
        SearchPostsRouter(
            viewController: viewController,
            scenes: sceneModule
        )
    }
    
    func component() -> ConstantsType {
        appModule.component()
    }
    
    func component() -> Theme {
        appModule.component()
    }
}
