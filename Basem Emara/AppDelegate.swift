//
//  AppDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 5/13/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppPressable {

    var window: UIWindow?

    override init() {
        super.init()
        AppGlobal.userDefaults.registerSite()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return didFinishLaunchingSite(application, launchOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return continueUserActivity(application, userActivity: userActivity, restorationHandler: restorationHandler)
    }
}
