//
//  DeepLinkApplicationModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress
import ZamzamUI

final class DeepLinkApplicationPlugin: ApplicationPlugin, Loggable {
    @Inject private var appModule: SwiftyPressModule
    @Inject private var sceneModule: SceneModuleType
    
    private lazy var router: DeepLinkRoutable = DeepLinkRouter(
        viewController: UIWindow.current?.rootViewController,
        scenes: sceneModule,
        constants: appModule.component()
    )
    
    private lazy var postWorker: PostWorkerType = appModule.component()
    private lazy var taxonomyWorker: TaxonomyWorkerType = appModule.component()
    private lazy var theme: Theme = appModule.component()
}

extension DeepLinkApplicationPlugin {
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let webpageURL = userActivity.webpageURL else {
            return false
        }
        
        Log(debug: "Link passed to app: \(webpageURL.absoluteString)")
        return navigate(from: webpageURL)
    }
}

private extension DeepLinkApplicationPlugin {
    
    /**
     Navigates to the view by URL
     
     - parameter url: URL requested.
     
     - returns: True if the navigation was successful, otherwise false.
     */
    func navigate(from url: URL) -> Bool {
        // Get root container and extract path from URL if applicable
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }
        
        // Handle url if applicable
        if url.path.isEmpty || url.path == "/" {
            // Handle search if applicable
            guard let query = urlComponents.queryItems?.first(where: { $0.name == "s" })?.value else {
                router.show(tab: .blog)
                return true
            }
            
            router.show(tab: .search) { (controller: SearchPostsViewController) in
                controller.searchText = query

                if controller.isViewLoaded {
                    controller.loadData()
                }
            }
            
            return true
        } else if let id = postWorker.getID(byURL: url.absoluteString) {
            router.showPost(for: id)
            return true
        } else if let id = taxonomyWorker.getID(byURL: url.absoluteString) {
            router.show(tab: .blog) { (controller: ShowBlogViewController) in
                controller.router.listPosts(
                    params: .init(fetchType: .terms([id]))
                )
            }
            
            return true
        }
        
        // Failed so open in Safari as fallback
        let destination = url.appendingQueryItem("mobileembed", value: 1).absoluteString
        router.present(safari: destination, theme: theme)
        return true
    }
}

protocol DeepLinkRoutable: AppRoutable {
    var scenes: SceneModuleType { get }
    var constants: ConstantsType { get }
    
    func showPost(for id: Int)
    func showFavorites()
    func sendFeedback()
}

extension DeepLinkRoutable {
    
    func showPost(for id: Int) {
        guard let topViewController = UIWindow.current?.topViewController else {
            return
        }
        
        // Load post in place or show in new controller
        (topViewController as? ShowPostLoadable)?.loadData(for: id)
            ?? topViewController.show(scenes.showPost(for: id), dismiss: true)
    }
    
    func showFavorites() {
        show(tab: .favorites)
    }
    
    func sendFeedback() {
        show(tab: .more) { (controller: ShowMoreViewController) in
            controller.router.sendFeedback(
                subject: .localizedFormat(
                    .emailFeedbackSubject,
                    self.constants.appDisplayName ?? ""
                )
            )
        }
    }
}

struct DeepLinkRouter: DeepLinkRoutable {
    weak var viewController: UIViewController?
    
    let scenes: SceneModuleType
    let constants: ConstantsType
    
    init(
        viewController: UIViewController?,
        scenes: SceneModuleType,
        constants: ConstantsType
    ) {
        self.viewController = viewController
        self.scenes = scenes
        self.constants = constants
    }
}
