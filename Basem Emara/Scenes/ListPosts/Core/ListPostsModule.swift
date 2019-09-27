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
    @Inject private var appModule: SwiftyPressModule
    @Inject private var sceneModule: SceneModuleType
    
    func component(with viewController: ListPostsDisplayable?) -> ListPostsActionable {
        ListPostsAction(
            presenter: component(with: viewController),
            postWorker: appModule.component(),
            mediaWorker: appModule.component()
        )
    }
    
    func component(with viewController: ListPostsDisplayable?) -> ListPostsPresentable {
        ListPostsPresenter(viewController: viewController)
    }
    
    func component(with viewController: UIViewController?) -> ListPostsRoutable {
        ListPostsRouter(
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