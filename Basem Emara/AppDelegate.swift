//
//  AppDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

@UIApplicationMain
class AppDelegate: ApplicationPluggableDelegate {

    override func plugins() -> [ApplicationPlugin] {
        [
            DependencyPlugin(),
            LoggerPlugin(),
            DataPlugin(),
            BackgroundPlugin(),
            WindowPlugin(for: window),
            ShortcutPlugin(),
            NotificationPlugin(),
            ThemePlugin()
        ]
    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        lazyPlugins.compactMap { $0 as? BackgroundPlugin }.first?
            .application(application, performFetchWithCompletionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        lazyPlugins.compactMap { $0 as? ShortcutPlugin }.first?
            .application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        DeepLinkPlugin()
            .application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
}
