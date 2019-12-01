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
    @Inject private var appModule: SwiftyPressModule
    @Inject private var sceneModule: SceneModuleType
    
    func component(with viewController: ShowPostDisplayable?) -> ShowPostActionable {
        ShowPostAction(
            presenter: component(with: viewController),
            postProvider: appModule.component(),
            mediaProvider: appModule.component(),
            authorProvider: appModule.component(),
            taxonomyProvider: appModule.component()
        )
    }
    
    func component(with viewController: ShowPostDisplayable?) -> ShowPostPresentable {
        ShowPostPresenter(
            viewController: viewController,
            constants: appModule.component()
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
        appModule.component()
    }
    
    func component() -> ConstantsType {
        appModule.component()
    }
    
    func component() -> Theme {
        appModule.component()
    }
}
