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
            render: WindowRender(render: render),
            preferences: core.dependency()
        ),
        NotificationPlugin(
            router: NotificationRouter(render: render),
            userNotification: .current()
        ),
        ShortcutPlugin(
            router: ShortcutRouter(
                render: render,
                constants: core.dependency()
            )
        ),
        DeepLinkPlugin(
            core: DeepLinkCore(
                core: core,
                render: render
            ),
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

private enum Root {
    
    /// Root dependency injection container
    static let core = AppCore()
    
    /// Root builder for all scenes.
    ///
    ///     NavigationView(
    ///         render.listArticles()
    ///     )
    ///
    /// Create views only through scene renders.
    static let render = SceneRender(
        core: core
    )
}

private extension UIApplicationDelegate {
    var core: SwiftyPressCore { Root.core }
    var render: SceneRender { Root.render }
}

@available(iOS 13.0, *)
extension UISceneDelegate {
    var core: SwiftyPressCore { Root.core }
    var render: SceneRender { Root.render }
}
