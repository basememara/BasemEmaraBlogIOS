//
//  CoreApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

final class CoreApplicationService: ApplicationService, DependencyConfigurator {
    
}

extension CoreApplicationService {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        register(dependencies: AppDependency())
        return true
    }
}
