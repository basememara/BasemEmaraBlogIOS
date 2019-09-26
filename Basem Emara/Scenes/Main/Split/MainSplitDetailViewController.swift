//
//  MainSplitDetailViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-27.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

class MainSplitDetailViewController: MainViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Setup

private extension MainSplitDetailViewController {
    
    func configure() {
        contentViewController.navigationItem.leftBarButtonItem =
            splitViewController?.displayModeButtonItem
    }
}

// MARK: - Delegates

extension MainSplitDetailViewController {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if splitViewController?.isCollapsed == false {
            viewControllers?.forEach { $0.navigationItem.leftBarButtonItem = nil }
            viewController.contentViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        }
        
        return true
    }
}
