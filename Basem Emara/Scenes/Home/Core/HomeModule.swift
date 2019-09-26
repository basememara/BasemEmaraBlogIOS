//
//  HomeModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress
import ZamzamUI

struct HomeModule: HomeModuleType {
    @Inject private var appModule: SwiftyPressModule
    @Inject private var sceneModule: SceneModuleType
    
    func component(with inputs: HomeAPI.RoutableInputs) -> HomeRoutable {
        HomeRouter(
            viewController: inputs.viewController,
            listPostsDelegate: inputs.listPostsDelegate,
            scenes: sceneModule,
            mailComposer: appModule.component(),
            constants: appModule.component(),
            theme: appModule.component()
        )
    }
    
    func component() -> ConstantsType {
        appModule.component()
    }
    
    func component() -> Theme {
        appModule.component()
    }
}
