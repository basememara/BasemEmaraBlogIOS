//
//  BootApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

final class WindowPlugin {
    private weak var delegate: WindowDelegate?
    
    private let render: WindowRenderable
    private let preferences: Preferences
    
    // MARK: - Lifecycle
    
    init(
        delegate: WindowDelegate?,
        render: WindowRenderable,
        preferences: Preferences
    ) {
        self.delegate = delegate
        self.render = render
        self.preferences = preferences
    }
}

// iOS 12 and below
extension WindowPlugin: ApplicationPlugin {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13, *) {} else {
            delegate?.window = UIWindow(frame: UIScreen.main.bounds).apply {
                $0.rootViewController = render.launchMain()
                $0.makeKeyAndVisible()
            }
        }
        
        return true
    }
}

// iOS 13+
extension WindowPlugin: ScenePlugin {
    
    @available(iOS 13, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        
        delegate?.window = UIWindow(windowScene: scene).apply {
            // Default to dark theme if not specified
            if !preferences.autoThemeEnabled {
                $0.overrideUserInterfaceStyle = .dark
            }
            
            $0.rootViewController = render.launchMain()
            $0.makeKeyAndVisible()
        }
    }
}

// MARK: - Helpers

protocol WindowDelegate: class {
    var window: UIWindow? { get set }
}

@available(iOS 13, *)
extension ScenePluggableDelegate: WindowDelegate {}
extension ApplicationPluggableDelegate: WindowDelegate {} // iOS 12 and below
