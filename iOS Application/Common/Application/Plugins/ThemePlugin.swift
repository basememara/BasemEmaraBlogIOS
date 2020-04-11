//
//  ThemeApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ThemePlugin {
    private let theme: Theme
    
    init(theme: Theme) {
        self.theme = theme
    }
}

// iOS 12 and below
extension ThemePlugin: ApplicationPlugin {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {} else {
            theme.apply(for: .current)
        }
        
        return true
    }
}

// iOS 13+
extension ThemePlugin: ScenePlugin {
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        theme.apply(for: .current)
    }
}
