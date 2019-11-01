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
        ShortcutPlugin.shared
    ]}
}

@available(iOS 13.0, *)
extension SceneDelegate {
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: scene).with {
            $0.overrideUserInterfaceStyle = .dark
            $0.rootViewController = scenes.startMain()
            $0.makeKeyAndVisible()
        }
    }
}
