//
//  AppRoutable.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit

protocol AppRoutable: Router {
    var viewController: UIViewController? { get set }
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

// MARK: - Helper functions

extension AppRoutable {
    
    private var rootController: UITabBarController? {
        return UIApplication.getWindow()?.rootViewController as? UITabBarController
    }
    
    func present<T: UIViewController>(storyboard: Storyboard, inBundle bundle: Bundle? = nil, identifier: String? = nil, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, modalTransitionStyle: UIModalTransitionStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) {
        present(storyboard: storyboard.rawValue, inBundle: bundle, identifier: identifier, animated: animated, modalPresentationStyle: modalPresentationStyle, modalTransitionStyle: modalTransitionStyle, configure: configure, completion: completion)
    }
    
    func show<T: UIViewController>(storyboard: Storyboard, inBundle bundle: Bundle? = nil, identifier: String? = nil, configure: ((T) -> Void)? = nil) {
        show(storyboard: storyboard.rawValue, inBundle: bundle, identifier: identifier, configure: configure)
    }
}

extension AppRoutable {
    
    /// Shows the main screen of the specified tab.
    ///
    /// - Parameters:
    ///   - tab: The tab to select.
    ///   - configure: Configure the view controller before it is loaded.
    ///   - completion: Completion the view controller after it is loaded.
    func show<T: UIViewController>(tab: TabStoryboard, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) {
        guard let tabBarController = rootController else { return }
        
        // Dismiss any alerts if applicable
        tabBarController.dismiss(animated: false, completion: nil)
        
        // Determine destination controller
        guard let controller: T = {
                // Get root navigation controller of tab if applicable
                guard let navigationController = tabBarController
                    .viewControllers?.get(tab.rawValue) as? UINavigationController else {
                        return tabBarController.viewControllers?.get(tab.rawValue) as? T
                }
            
                return navigationController.viewControllers.first as? T
            }() else {
                // Select tab before exiting any way
                tabBarController.selectedIndex = tab.rawValue
                return
        }
        
        configure?(controller)
        
        // Select tab
        tabBarController.selectedIndex = tab.rawValue
        
        // Pop all views of navigation controller to go to root
        (tabBarController.selectedViewController as? UINavigationController)?
            .popToRootViewController(animated: false)
        
        completion?(controller)
    }
}

/// Storyboard identifiers for routing
enum Storyboard: String {
    case home = "Home"
    case listPosts = "ListPosts"
    case showPost = "ShowPost"
    case previewPost = "PreviewPost"
    case listTerms = "ListTerms"
    case showSettings = "ShowSettings"
}

enum TabStoryboard: Int {
    case home = 0
    case favorites = 1
    case search = 2
    case more = 3
}

