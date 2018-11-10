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
            CoreApplicationModule(),
            LoggerApplicationModule(),
            DataApplicationModule(),
            BackgroundApplicationModule(),
            WindowApplicationModule(for: window),
            ShortcutApplicationModule(),
            NotificationApplicationModule(),
            ThemeApplicationModule()
        ]
    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        BackgroundApplicationModule()
            .application(application, performFetchWithCompletionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        ShortcutApplicationModule()
            .application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return DeepLinkApplicationModule()
            .application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
}

