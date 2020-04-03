//
//  MainSplitDetailViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-27.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

class MainSplitDetailViewController: MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
}

// MARK: - Configure

private extension MainSplitDetailViewController {
    
    func prepare() {
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
