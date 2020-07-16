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
        LoggerPlugin(log: core.log()),
        DataPlugin(dataRepository: core.dataRepository()),
        BackgroundPlugin(
            dataRepository: core.dataRepository(),
            preferences: core.preferences(),
            log: core.log()
        ),
        WindowPlugin(
            delegate: self,
            render: WindowRender(render: render),
            preferences: core.preferences()
        ),
        ThemePlugin(theme: core.theme()),
        NotificationPlugin(
            render: NotificationRender(render: render),
            userNotification: .current()
        ),
        ShortcutPlugin(
            render: ShortcutRender(
                render: render,
                constants: core.constants()
            )
        ),
        DeepLinkPlugin(
            render: DeepLinkRender(
                render: render,
                postRepository: core.postRepository(),
                taxonomyRepository: core.taxonomyRepository(),
                theme: core.theme()
            ),
            log: core.log()
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

private enum AppRoot {
    
    /// Root dependency injection container.
    static let core = AppCore()
    
    /// Root store.
    static let store = AppStore()
    
    /// Root builder for all scenes.
    ///
    ///     NavigationView(
    ///         render.listArticles()
    ///     )
    ///
    /// Create views only through scene renders.
    static let render = AppRender(
        core: core,
        store: store
    )
}

private extension UIApplicationDelegate {
    var core: AppCore { AppRoot.core }
    var render: AppRender { AppRoot.render }
}

@available(iOS 13, *)
extension UISceneDelegate {
    var core: AppCore { AppRoot.core }
    var render: AppRender { AppRoot.render }
}
