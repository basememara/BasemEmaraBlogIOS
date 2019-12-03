//
//  File.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

final class ShortcutPlugin {
    private let deepLinkModule: DeepLinkModuleType
    private let router: DeepLinkRoutable
    
    // MARK: - State
    
    private var launchedShortcutItem: UIApplicationShortcutItem?
    
    init(deepLinkModule: DeepLinkModuleType) {
        self.deepLinkModule = deepLinkModule
        self.router = deepLinkModule.component()
    }
}

// iOS 12 and below
extension ShortcutPlugin: ApplicationPlugin {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem else {
            return true
        }
        
        launchedShortcutItem = shortcutItem
        return false //Prevent "performActionForShortcutItem" from being called
    }
}

// iOS 13+
extension ShortcutPlugin: ScenePlugin {
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let shortcutItem = connectionOptions.shortcutItem else { return }
        launchedShortcutItem = shortcutItem
    }
    
    func sceneDidBecomeActive() {
        guard let shortcut = launchedShortcutItem else { return }
        performShortcutAction(for: shortcut)
        launchedShortcutItem = nil //Reset for next use
    }
    
    func scene(performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(performShortcutAction(for: shortcutItem))
    }
}

private extension ShortcutPlugin {
    
    /// Handle actions performed by home screen shortcuts
    /// - Returns: A Boolean value indicating whether or not the shortcut action succeeded.
    @discardableResult
    func performShortcutAction(for shortcutItem: UIApplicationShortcutItem) -> Bool {
        guard let shortcutItemType = ShortcutItemType(for: shortcutItem) else {
            return false
        }
        
        switch shortcutItemType {
        case .favorites:
            router.showFavorites()
        case .contact:
            router.sendFeedback()
        }
        
        return true
    }
}

private extension ShortcutPlugin {
    
    enum ShortcutItemType: String {
        case favorites
        case contact
        
        init?(for shortcutItem: UIApplicationShortcutItem) {
            guard let type = shortcutItem.type
                .components(separatedBy: ".").last else {
                    return nil
            }
            
            self.init(rawValue: type)
        }
    }
}
