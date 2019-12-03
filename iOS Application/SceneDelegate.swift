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
    
    // MARK: - Dependencies
    
    @Inject private var scenes: SceneRenderType
    
    // MARK: - Overrides
    
    override func plugins() -> [ScenePlugin] {[
        LoggerPlugin(log: core.dependency()),
        BackgroundPlugin(
            dataProvider: core.dependency(),
            preferences: core.dependency(),
            log: core.dependency()
        ),
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

@available(iOS 13.0, *)
extension SceneDelegate {
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        pluginInstances.compactMap { $0 as? ShortcutPlugin }.first?
            .scene(performActionFor: shortcutItem, completionHandler: completionHandler)
    }
}
