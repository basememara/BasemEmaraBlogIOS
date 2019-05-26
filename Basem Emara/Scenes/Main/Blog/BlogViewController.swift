//
//  BlogViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class BlogViewController: UITabBarController, HasDependencies {
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

// MARK: - Delegates

extension BlogViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Special handling per tab if needed
        switch (viewController as? UINavigationController)?.topViewController {
        case let controller as ShowDashboardViewController:
            // Reset scroll to top when tab selected
            controller.scrollToTop(animated: true)
        default:
            break
        }
    }
}
