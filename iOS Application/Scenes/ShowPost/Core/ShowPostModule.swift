//
//  ShowPostModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ShowPostModule: ShowPostModuleType {
    @Inject private var appModule: SwiftyPressCore
    @Inject private var sceneModule: SceneRenderType
    
    func component(with viewController: ShowPostDisplayable?) -> ShowPostActionable {
        ShowPostAction(
            presenter: component(with: viewController),
            postProvider: appModule.dependency(),
            mediaProvider: appModule.dependency(),
            authorProvider: appModule.dependency(),
            taxonomyProvider: appModule.dependency()
        )
    }
    
    func component(with viewController: ShowPostDisplayable?) -> ShowPostPresentable {
        ShowPostPresenter(
            viewController: viewController,
            constants: appModule.dependency()
        )
    }
    
    func component(with inputs: ShowPostAPI.RoutableInputs) -> ShowPostRoutable {
        ShowPostRouter(
            viewController: inputs.viewController,
            listPostsDelegate: inputs.listPostsDelegate,
            scenes: sceneModule
        )
    }
    
    func component() -> NotificationCenter {
        appModule.dependency()
    }
    
    func component() -> ConstantsType {
        appModule.dependency()
    }
    
    func component() -> Theme {
        appModule.dependency()
    }
}
