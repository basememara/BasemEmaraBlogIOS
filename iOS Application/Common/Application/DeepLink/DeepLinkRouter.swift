//
//  DeepLinkRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-28.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftyPress
import UIKit

struct DeepLinkRouter: DeepLinkRoutable {
    weak var viewController: UIViewController?
    
    private let scenes: SceneModuleType
    private let postProvider: PostProviderType
    private let taxonomyProvider: TaxonomyProviderType
    private let constants: ConstantsType
    private let theme: Theme
    
    init(
        viewController: UIViewController?,
        scenes: SceneModuleType,
        postProvider: PostProviderType,
        taxonomyProvider: TaxonomyProviderType,
        constants: ConstantsType,
        theme: Theme
    ) {
        self.viewController = viewController
        self.scenes = scenes
        self.postProvider = postProvider
        self.taxonomyProvider = taxonomyProvider
        self.constants = constants
        self.theme = theme
    }
}

extension DeepLinkRouter {
    
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

extension DeepLinkRouter {
    
    /// Navigates to the view by URL.
    /// - Parameter url: URL requested.
    /// - Returns: True if the navigation was successful, otherwise false.
    func navigate(from url: URL) -> Bool {
        // Get root container and extract path from URL if applicable
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }
        
        // Handle url if applicable
        if url.path.isEmpty || url.path == "/" {
            // Handle search if applicable
            guard let query = urlComponents.queryItems?.first(where: { $0.name == "s" })?.value else {
                show(tab: .blog)
                return true
            }
            
            show(tab: .search) { (controller: SearchPostsViewController) in
                controller.searchText = query

                if controller.isViewLoaded {
                    controller.loadData()
                }
            }
            
            return true
        } else if let id = postProvider.getID(byURL: url.absoluteString) {
            showPost(for: id)
            return true
        } else if let id = taxonomyProvider.getID(byURL: url.absoluteString) {
            show(tab: .blog) { (controller: ShowBlogViewController) in
                controller.router.listPosts(
                    params: .init(fetchType: .terms([id]))
                )
            }
            
            return true
        }
        
        // Failed so open in Safari as fallback
        let destination = url.appendingQueryItem("mobileembed", value: 1).absoluteString
        present(safari: destination, theme: theme)
        return true
    }
}
