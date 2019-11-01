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

final class DeepLinkPlugin: ApplicationPlugin {
    @Inject private var module: DeepLinkModuleType
    
    private lazy var router: DeepLinkRoutable = module.component()
    private lazy var log: LogWorkerType = module.component()
}

extension DeepLinkPlugin {
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let webpageURL = userActivity.webpageURL else {
            return false
        }
        
        log.debug("Link passed to app: \(webpageURL.absoluteString)")
        return router.navigate(from: webpageURL)
    }
}
