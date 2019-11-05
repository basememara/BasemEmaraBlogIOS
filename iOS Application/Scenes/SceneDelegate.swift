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
    
    @Inject private var scenes: SceneModuleType
    
    // MARK: - Overrides
    
    override func plugins() -> [ScenePlugin] {[
        LoggerPlugin.shared,
        BackgroundPlugin(),
        WindowPlugin(for: self),
        NotificationPlugin.shared,
        ShortcutPlugin.shared,
        DeepLinkPlugin()
    ]}
}

@available(iOS 13.0, *)
extension SceneDelegate {
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        pluginInstances.compactMap { $0 as? ShortcutPlugin }.first?
            .scene(performActionFor: shortcutItem, completionHandler: completionHandler)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        pluginInstances.compactMap { $0 as? DeepLinkPlugin }.first?
            .scene(scene, continue: userActivity)
    }
}
