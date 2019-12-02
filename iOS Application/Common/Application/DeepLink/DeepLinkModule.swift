//
//  DeepLinkModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-28.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftyPress
import UIKit
import ZamzamCore

struct DeepLinkModule: DeepLinkModuleType {
    @Inject private var appModule: SwiftyPressCore
    @Inject private var sceneModule: SceneRenderType
    
    func component() -> DeepLinkRoutable {
        DeepLinkRouter(
            viewController: UIWindow.current?.rootViewController,
            scenes: sceneModule,
            postProvider: appModule.dependency(),
            taxonomyProvider: appModule.dependency(),
            constants: appModule.dependency(),
            theme: appModule.dependency()
        )
    }
    
    func component() -> LogProviderType {
        appModule.dependency()
    }
}
