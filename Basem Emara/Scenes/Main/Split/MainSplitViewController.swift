//
//  MainSplitViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress

class MainSplitViewController: UISplitViewController {
    
    // MARK: - Scene variables
    
    private lazy var router: MainSplitRoutable = MainSplitRouter(
        viewController: self,
        constants: constants
    )
    
    // MARK: - Internal variable
    
    @Inject private var constants: ConstantsType
    @Inject private var theme: Theme
    
    // MARK: - Controller cycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return theme.statusBarStyle
    }
}

// MARK: - Delegates

extension MainSplitViewController: ListPostsDelegate {
    
    func listPosts(_ viewController: UIViewController, didSelect postID: Int) {
        router.showPost(for: postID)
    }
}
