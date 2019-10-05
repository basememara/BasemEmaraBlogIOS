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

final class LoggerPlugin: ApplicationPlugin, Loggable {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogger(for: application)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Log(info: "App did finish launching.")
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Log(debug: "App did enter background.")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Log(debug: "App will enter background.")
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        Log(warn: "App did receive memory warning.")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Log(warn: "App will terminate.")
    }
}
