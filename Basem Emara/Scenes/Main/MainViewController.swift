//
//  MainViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class MainViewController: UITabBarController, HasDependencies {
    
    // MARK: - VIP variables
    
    lazy var router: MainRoutable = MainRouter(
        viewController: self,
        constants: dependencies.resolve()
    )
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

// MARK: - Delegates

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Reset scroll to top when tab selected
        switch (viewController as? UINavigationController)?.topViewController {
        case let controller where controller is HomeViewController && controller?.isViewLoaded == true:
            (controller as? HomeViewController)?.scrollView.scrollToTop()
        default: break
        }
    }
}
