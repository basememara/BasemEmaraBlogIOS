//
//  ShowBlogModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

struct ShowBlogModule: ShowBlogModuleType {
    @Inject private var appModule: SwiftyPressCore
    @Inject private var sceneModule: SceneRenderType
    
    func component(with viewController: ShowBlogDisplayable?) -> ShowBlogActionable {
        ShowBlogAction(
            presenter: component(with: viewController),
            postProvider: appModule.dependency(),
            mediaProvider: appModule.dependency(),
            taxonomyProvider: appModule.dependency(),
            preferences: appModule.dependency()
        )
    }
    
    func component(with viewController: ShowBlogDisplayable?) -> ShowBlogPresentable {
        ShowBlogPresenter(viewController: viewController)
    }
    
    func component(with viewController: UIViewController?) -> ShowBlogRoutable {
        ShowBlogRouter(
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
    
    func component() -> MailComposerType {
        appModule.dependency()
    }
}
