//
//  AppDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

@UIApplicationMain
class AppDelegate: ApplicationModuleDelegate {

    override func modules() -> [ApplicationModule] {
        return [
            DependencyApplicationModule(),
            LoggerApplicationModule(),
            DataApplicationModule(),
            WindowApplicationModule(for: window),
            ThemeApplicationModule()
        ]
    }
}
