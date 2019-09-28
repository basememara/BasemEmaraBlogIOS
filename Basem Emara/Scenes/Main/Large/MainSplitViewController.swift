//
//  MainSplitViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

class MainSplitViewController: UISplitViewController {
    
    // MARK: - Dependencies
    
    @Inject private var appModule: SwiftyPressModule
    @Inject private var deepLinkModule: DeepLinkModuleType
    
    private lazy var router: DeepLinkRoutable = deepLinkModule.component()
    private lazy var theme: Theme = appModule.component()
    
    // MARK: - Lifecycle
    
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
