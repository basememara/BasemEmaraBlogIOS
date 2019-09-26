//
//  ShowMoreModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress

struct ShowMoreModule: ShowMoreModuleType {
    @Inject private var appModule: SwiftyPressModule
    @Inject private var sceneModule: SceneModuleType
    
    func component(with viewController: UIViewController?) -> ShowMoreRoutable {
        ShowMoreRouter(
            viewController: viewController,
            scenes: sceneModule,
            constants: appModule.component(),
            mailComposer: appModule.component(),
            theme: appModule.component()
        )
    }
    
    func component() -> ConstantsType {
        appModule.component()
    }
}
