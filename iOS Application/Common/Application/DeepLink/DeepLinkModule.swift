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
    @Inject private var appModule: SwiftyPressModule
    @Inject private var sceneModule: SceneModuleType
    
    func component() -> DeepLinkRoutable {
        DeepLinkRouter(
            viewController: UIWindow.current?.rootViewController,
            scenes: sceneModule,
            postWorker: appModule.component(),
            taxonomyWorker: appModule.component(),
            constants: appModule.component(),
            theme: appModule.component()
        )
    }
    
    func component() -> LogWorkerType {
        appModule.component()
    }
}
