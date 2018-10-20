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
class AppDelegate: PluggableApplicationDelegate {

    override func services() -> [ApplicationService] {
        return [
            CoreApplicationService(),
            LoggerApplicationService(),
            DataApplicationService(),
            BootApplicationService(with: window),
            ThemeApplicationService()
        ]
    }
}
