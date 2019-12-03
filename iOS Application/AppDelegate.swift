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

    override func plugins() -> [ApplicationPlugin] {[
        DependencyPlugin(),
        LoggerPlugin(log: core.dependency()),
        DataPlugin(dataProvider: core.dependency()),
        BackgroundPlugin(
            dataProvider: core.dependency(),
            preferences: core.dependency(),
            log: core.dependency()
        ),
        ThemePlugin(theme: core.dependency()),
        WindowPlugin(
            delegate: self,
            scenes: SceneRender(core: core),
            preferences: core.dependency()
        ),
        NotificationPlugin(
            deepLinkModule: DeepLinkModule(),
            userNotification: .current()
        ),
        ShortcutPlugin(deepLinkModule: DeepLinkModule()),
        DeepLinkPlugin(
            module: DeepLinkModule(),
            log: core.dependency()
        )
    ]}
}

extension AppDelegate {
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        pluginInstances.compactMap { $0 as? BackgroundPlugin }.first?
            .application(application, performFetchWithCompletionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        pluginInstances.compactMap { $0 as? ShortcutPlugin }.first?
            .scene(performActionFor: shortcutItem, completionHandler: completionHandler)
    }
}

// MARK: - Environment Components

private extension UIApplication {
    static let core = AppCore()
}

extension UIApplicationDelegate {
    var core: SwiftyPressCore { UIApplication.core }
}

@available(iOS 13.0, *)
extension UISceneDelegate {
    var core: SwiftyPressCore { UIApplication.core }
}
