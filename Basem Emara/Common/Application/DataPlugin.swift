//
//  DataApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-19.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

final class DataPlugin: ApplicationPlugin {
    @Inject private var module: SwiftyPressModule
    private lazy var dataWorker: DataWorkerType = module.component()
}

extension DataPlugin {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dataWorker.configure()
        return true
    }
}
