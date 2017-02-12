//
//  AppDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 5/13/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyPress
import Fabric
import Crashlytics
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppPressable {

    var window: UIWindow?
    var urlSessionManager: SessionManager?

    override init() {
        super.init()
        AppGlobal.userDefaults.registerSite()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        return didFinishLaunchingSite(application, launchOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return continueUserActivity(application, userActivity: userActivity, restorationHandler: restorationHandler)
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        performFetch(application, completionHandler: completionHandler)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        didReceiveUserNotification(response: response, withCompletionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        performActionForShortcutItem(application, shortcutItem: shortcutItem, completionHandler: completionHandler)
    }
}
