//
//  ThemeApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

final class ThemeApplicationPlugin: ApplicationPlugin {
    @Inject private var module: SwiftyPressModule
    private lazy var theme: Theme = module.component()
}

extension ThemeApplicationPlugin {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        theme.apply(for: application)
        return true
    }
}
