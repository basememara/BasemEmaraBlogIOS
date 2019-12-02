//
//  ShowMoreModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ShowMoreModule: ShowMoreModuleType {
    @Inject private var appModule: SwiftyPressCore
    @Inject private var sceneModule: SceneRenderType
    
    func component(with viewController: UIViewController?) -> ShowMoreRoutable {
        ShowMoreRouter(
            viewController: viewController,
            scenes: sceneModule,
            constants: appModule.dependency(),
            mailComposer: appModule.dependency(),
            theme: appModule.dependency()
        )
    }
    
    func component() -> ConstantsType {
        appModule.dependency()
    }
}
