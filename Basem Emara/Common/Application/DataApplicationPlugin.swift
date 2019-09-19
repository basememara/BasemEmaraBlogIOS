//
//  DataApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-19.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress
import ZamzamUI

final class DataApplicationPlugin: ApplicationPlugin {
    @Inject private var dataWorker: DataWorkerType
}

extension DataApplicationPlugin {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dataWorker.configure()
        return true
    }
}
