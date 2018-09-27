//
//  ThemeApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

final class ThemeApplicationService: ApplicationService, HasDependencies {
    private lazy var themeWorker: ThemeWorkerType = dependencies.resolveWorker()
}

extension ThemeApplicationService {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        themeWorker.apply(for: application)
        return true
    }
}
