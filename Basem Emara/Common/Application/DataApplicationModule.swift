//
//  DataApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-19.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI

final class DataApplicationModule: ApplicationModule, HasDependencies {
    private lazy var dataWorker: DataWorkerType = dependencies.resolve()
}

extension DataApplicationModule {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dataWorker.configure()
        return true
    }
}
