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
    @Inject private var appModule: SwiftyPressModule
    @Inject private var sceneModule: SceneModuleType
    
    func component(with viewController: ShowBlogDisplayable?) -> ShowBlogActionable {
        ShowBlogAction(
            presenter: component(with: viewController),
            postProvider: appModule.component(),
            mediaProvider: appModule.component(),
            taxonomyProvider: appModule.component(),
            preferences: appModule.component()
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
        appModule.component()
    }
    
    func component() -> Theme {
        appModule.component()
    }
    
    func component() -> MailComposerType {
        appModule.component()
    }
}
