//
//  BootApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

final class BootApplicationService: ApplicationService {
    private var window: UIWindow?
    
    init(with window: UIWindow?) {
        self.window = window
    }
}

extension BootApplicationService {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        return true
    }
}
