//
//  ListPostsModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ListPostsModule: ListPostsModuleType {
    @Inject private var appModule: SwiftyPressCore
    @Inject private var sceneModule: SceneRenderType
    
    func component(with viewController: ListPostsDisplayable?) -> ListPostsActionable {
        ListPostsAction(
            presenter: component(with: viewController),
            postProvider: appModule.dependency(),
            mediaProvider: appModule.dependency()
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
        appModule.dependency()
    }
    
    func component() -> Theme {
        appModule.dependency()
    }
}
