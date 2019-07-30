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
            CoreApplicationModule(with: AppConfigurator()),
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
        lazyModules.compactMap { $0 as? BackgroundApplicationModule }.first?
            .application(application, performFetchWithCompletionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        lazyModules.compactMap { $0 as? ShortcutApplicationModule }.first?
            .application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return DeepLinkApplicationModule()
            .application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
}
