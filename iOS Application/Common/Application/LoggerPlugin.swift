//
//  LoggerApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct LoggerPlugin: Loggable {
    static let shared = LoggerPlugin()
}

extension LoggerPlugin: ApplicationPlugin {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogger(for: application)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Log(info: "App did finish launching.")
        return true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        Log(warn: "App did receive memory warning.")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Log(warn: "App will terminate.")
    }
}

// iOS 12 and below
extension LoggerPlugin {
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Log(debug: "App will enter foreground.")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Log(debug: "App did enter background.")
    }
}

// iOS 13+
extension LoggerPlugin: ScenePlugin {
    
    func sceneWillEnterForeground() {
        Log(debug: "App will enter foreground.")
    }
    
    func sceneDidEnterBackground() {
        Log(debug: "App did enter background.")
    }
    
    func sceneDidBecomeActive() {
        Log(debug: "App did become active.")
    }
    
    func sceneWillResignActive() {
        Log(debug: "App did will resign active.")
    }
}
