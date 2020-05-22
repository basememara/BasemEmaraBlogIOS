//
//  SceneDelegate.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-10-06.
//

import UIKit
import SwiftyPress
import ZamzamCore

@available(iOS 13, *)
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
        ThemePlugin(theme: core.theme()),
        NotificationPlugin(
            router: NotificationRender(render: render),
            userNotification: .current()
        ),
        ShortcutPlugin(
            router: ShortcutRender(
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

@available(iOS 13, *)
extension SceneDelegate {
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        pluginInstances.compactMap { $0 as? ShortcutPlugin }.first?
            .scene(performActionFor: shortcutItem, completionHandler: completionHandler)
    }
}
