//
//  AppDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, Loggable {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        setupLogger(for: application)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        
        // Theme
        window?.tintColor = .tint
        UITabBar.appearance().barStyle = .black
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .tint
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.title
        ]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.title
            ]
        }
        UICollectionView.appearance().backgroundColor = .black
        UITableView.appearance().backgroundColor = .black
        UITableViewCell.appearance().backgroundColor = .clear
        
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

