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
import ZamzamUI

struct DeepLinkRouter: DeepLinkRouterable {
    private let render: SceneRenderType
    private let postRepository: PostRepositoryType
    private let taxonomyRepository: TaxonomyRepositoryType
    private let theme: Theme
    
    weak var viewController = UIApplication.shared.currentWindow?.rootViewController
    
    init(
        render: SceneRenderType,
        postRepository: PostRepositoryType,
        taxonomyRepository: TaxonomyRepositoryType,
        theme: Theme
    ) {
        self.render = render
        self.postRepository = postRepository
        self.taxonomyRepository = taxonomyRepository
        self.theme = theme
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
                viewController?.show(menu: MainAPI.Menu.blog)
                return true
            }
            
            viewController?.show(menu: MainAPI.Menu.search) { (controller: SearchPostsViewController) in
                controller.searchText = query

                if controller.isViewLoaded {
                    controller.fetch()
                }
            }
            
            return true
        } else if let id = postRepository.getID(byURL: url.absoluteString) {
            guard let topViewController = UIApplication.shared.currentWindow?.topViewController else {
                return false
            }
            
            // Load post in place or show in new controller
            (topViewController as? ShowPostLoadable)?.load(id)
                ?? topViewController.show(render.showPost(for: id), dismiss: true)
            
            return true
        } else if let id = taxonomyRepository.getID(byURL: url.absoluteString) {
            viewController?.show(menu: MainAPI.Menu.blog) { (controller: ShowBlogViewController) in
                controller.render?.listPosts(
                    params: .init(fetchType: .terms([id]))
                )
            }
            
            return true
        }
        
        // Failed so open in Safari as fallback
        let destination = url.appendingQueryItem("mobileembed", value: 1).absoluteString
        viewController?.modal(safari: destination, theme: theme)
        return true
    }
}
