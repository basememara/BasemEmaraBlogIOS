//
//  SceneDelegate.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-10-06.
//

import UIKit
import SwiftyPress
import ZamzamCore

@available(iOS 13.0, *)
class SceneDelegate: ScenePluggableDelegate {
    
    override func plugins() -> [ScenePlugin] {[
        LoggerPlugin(log: core.dependency()),
        BackgroundPlugin(
            dataProvider: core.dependency(),
            preferences: core.dependency(),
            log: core.dependency()
        ),
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

@available(iOS 13.0, *)
extension SceneDelegate {
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        pluginInstances.compactMap { $0 as? ShortcutPlugin }.first?
            .scene(performActionFor: shortcutItem, completionHandler: completionHandler)
    }
}
