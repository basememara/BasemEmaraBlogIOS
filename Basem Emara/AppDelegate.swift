//
//  AppDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 5/13/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppPressable {

    var window: UIWindow?

    override init() {
        super.init()
        AppGlobal.userDefaults.registerSite()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])
        return didFinishLaunchingSite(application, launchOptions: launchOptions)
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        return continueUserActivity(application, continueUserActivity: userActivity, restorationHandler: restorationHandler)
    }
}