//
//  AppRoutable.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI

extension AppRoutable {
    
    /// Setting this property changes the selected tab of the root tab view controller.
    ///
    /// - Parameters:
    ///   - index: The index of the view controller associated with the currently selected tab item.
    ///   - configure: Configure the view controller before it is loaded.
    ///   - completion: Completion the view controller after it is loaded.
    /// - Returns: Returns the view controller instance from the storyboard.
    @discardableResult
    func show<T: UIViewController>(tab: SceneModule.Tab, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) -> T? {
        // Handle tab bar controller in split view differently
        guard let splitViewController: UISplitViewController =
            viewController as? UISplitViewController
                ?? viewController?.splitViewController else {
                    // No split view
                    guard let tabBarController = UIWindow.current?
                        .rootViewController as? UITabBarController else {
                            return nil
                    }
                    
                    return tabBarController.setSelected(
                        index: tab.rawValue,
                        configure: configure,
                        completion: completion
                    )
        }
        
        guard let tabBarController = splitViewController
            .viewControllers.last as? UITabBarController else {
                return nil
        }
        
        return tabBarController.setSelected(
            index: max(tab.rawValue - 1, 0),
            configure: configure,
            completion: completion
        )
    }
}

extension AppRoutable {
    
    /// Open Safari view controller overlay.
    ///
    /// - Parameters:
    ///   - url: URL to display in the browser.
    ///   - constants: The app constants.
    ///   - theme: The style of the Safari view controller.
    func present(safari url: String, theme: Theme) {
        // Handle Safari display in split view differently
        viewController?.splitViewController?.present(safari: url, theme: theme)
            ?? viewController?.present(safari: url, theme: theme)
    }

    /// Open Safari view controller overlay.
    ///
    /// - Parameters:
    ///   - slug: The slug of the page.
    ///   - constants: The app constants.
    ///   - theme: The style of the Safari view controller.
    func present(pageSlug slug: String, constants: ConstantsType, theme: Theme) {
        let url = constants.baseURL
            .appendingPathComponent(slug)
            .appendingQueryItem("mobileembed", value: 1)
            .absoluteString
        
        present(safari: url, theme: theme)
    }
}

extension AppRoutable {
    
    func showSocial(for type: Social, theme: Theme) {
        // Open social app or url
        guard let shortcut = type.shortcut(for: "basememara"), UIApplication.shared.canOpenURL(shortcut) else {
            viewController?.present(safari: type.link(for: "basememara"), theme: theme)
            return
        }
        
        UIApplication.shared.open(shortcut)
    }
}
