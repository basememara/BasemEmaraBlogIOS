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
        LoggerPlugin(log: core.log()),
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
        NotificationPlugin(
            router: NotificationRouter(render: render),
            userNotification: .current()
        ),
        ShortcutPlugin(
            router: ShortcutRouter(
                render: render,
                constants: core.constants()
            )
        ),
        DeepLinkPlugin(
            core: DeepLinkCore(
                core: core,
                render: render
            ),
            log: core.log()
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
