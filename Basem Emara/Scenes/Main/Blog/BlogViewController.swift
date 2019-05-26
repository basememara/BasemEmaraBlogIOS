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
        configure()
    }
}

// MARK: - Events

private extension BlogViewController {
    
    func configure() {
        delegate = self
        
        if splitViewController?.isCollapsed == false {
            contentViewController.navigationItem.leftBarButtonItem =
                splitViewController?.displayModeButtonItem
        } else if isModal {
            contentViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                imageName: "menu-vertical",
                target: self,
                action: #selector(exit)
            )
        }
    }
}

// MARK: - Interaction

private extension BlogViewController {
    
    @objc func exit(_ sender: UIBarButtonItem) {
        dismiss()
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        viewControllers?.forEach { $0.navigationItem.leftBarButtonItem = nil }
        viewController.contentViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        return true
    }
}
