//
//  LoggerApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

final class LoggerApplicationService: ApplicationService, Loggable {
    
}

extension LoggerApplicationService {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupLogger(for: application)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
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
