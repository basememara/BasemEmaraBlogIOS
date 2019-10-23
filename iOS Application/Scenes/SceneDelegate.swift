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
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Dependencies
    
    @Inject private var module: SwiftyPressModule
    @Inject private var scenes: SceneModuleType
    
    private lazy var preferences: PreferencesType = module.component()
    
    // MARK: - State
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = scenes.startMain()
        window?.makeKeyAndVisible()
    }
}
