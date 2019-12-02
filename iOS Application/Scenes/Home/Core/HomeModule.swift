//
//  HomeModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

struct HomeModule: HomeModuleType {
    @Inject private var appModule: SwiftyPressCore
    @Inject private var sceneModule: SceneRenderType
    
    func component(with inputs: HomeAPI.RoutableInputs) -> HomeRoutable {
        HomeRouter(
            viewController: inputs.viewController,
            listPostsDelegate: inputs.listPostsDelegate,
            scenes: sceneModule,
            mailComposer: appModule.dependency(),
            constants: appModule.dependency(),
            theme: appModule.dependency()
        )
    }
    
    func component() -> ConstantsType {
        appModule.dependency()
    }
    
    func component() -> Theme {
        appModule.dependency()
    }
}
