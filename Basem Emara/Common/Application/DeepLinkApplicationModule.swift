//
//  DeepLinkApplicationModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

final class DeepLinkApplicationModule: ApplicationModule, HasDependencies, Loggable {
    private lazy var postWorker: PostWorkerType = dependencies.resolve()
    private lazy var taxonomyWorker: TaxonomyWorkerType = dependencies.resolve()
    private lazy var theme: Theme = dependencies.resolve()
}

extension DeepLinkApplicationModule {
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let webpageURL = userActivity.webpageURL else { return false }
        Log(debug: "Link passed to app: \(webpageURL.absoluteString)")
        return navigate(from: webpageURL)
    }
}

private extension DeepLinkApplicationModule {
    
    /**
     Navigates to the view by URL
     
     - parameter url: URL requested.
     
     - returns: True if the navigation was successful, otherwise false.
     */
    func navigate(from url: URL) -> Bool {
        // Get root container and extract path from URL if applicable
        guard let appViewController = (UIApplication.getWindow()?.rootViewController as? MainViewController),
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return false
        }
        
        // Handle url if applicable
        if url.path.isEmpty || url.path == "/" {
            // Handle search if applicable
            guard let query = urlComponents.queryItems?.first(where: { $0.name == "s" })?.value else {
                appViewController.router.show(tab: .home)
                return true
            }
            
            appViewController.router.show(tab: .search) { (controller: SearchPostsViewController) in
                controller.searchText = query

                if controller.isViewLoaded {
                    controller.loadData()
                }
            }
            
            return true
        } else if let id = postWorker.getID(byURL: url.absoluteString) {
            appViewController.router.show(tab: .home) { (controller: HomeViewController) in
                controller.router.showPost(for: id)
            }
            
            return true
        } else if let id = taxonomyWorker.getID(byURL: url.absoluteString) {
            appViewController.router.show(tab: .home) { (controller: HomeViewController) in
                controller.router.listPosts(for: .terms([id]))
            }
            
            return true
        }
        
        // Failed so open in Safari as fallback
        let destination = url.appendingQueryItem("mobileembed", value: 1).absoluteString
        appViewController.show(safari: destination, theme: theme)
        return true
    }
}
