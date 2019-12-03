//
//  DeepLinkApplicationModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct DeepLinkPlugin {
    private let module: DeepLinkModuleType
    private let router: DeepLinkRoutable
    private let log: LogProviderType
    
    init(
        module: DeepLinkModuleType,
        log: LogProviderType
    ) {
        self.module = module
        self.router = module.component()
        self.log = log
    }
}

extension DeepLinkPlugin: ApplicationPlugin {
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let webpageURL = userActivity.webpageURL else {
                return false
        }
        
        log.debug("Link passed to app: \(webpageURL.absoluteString)")
        return router.navigate(from: webpageURL)
    }
}

@available(iOS 13.0, *)
extension DeepLinkPlugin: ScenePlugin {
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let userActivity = connectionOptions.userActivities.first(where: { $0.activityType == NSUserActivityTypeBrowsingWeb }),
            let webpageURL = userActivity.webpageURL else {
                return
        }
        
        log.info("Link passed to app: \(webpageURL.absoluteString)")
        router.navigate(from: webpageURL)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let webpageURL = userActivity.webpageURL else {
                return
        }
        
        log.info("Link passed to app: \(webpageURL.absoluteString)")
        router.navigate(from: webpageURL)
    }
}
