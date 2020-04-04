//
//  MainSplitViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController {
    private let presenter: MainPresenterType
    
    init(presenter: MainPresenterType) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Delegates

extension MainSplitViewController: ListPostsDelegate {
    
    func listPosts(_ viewController: UIViewController, didSelect postID: Int) {
        guard let topViewController = UIWindow.current?.topViewController else { return }
        
        // Load post in place or show in new controller
        (topViewController as? ShowPostLoadable)?.load(postID)
            ?? topViewController.show(presenter.showPost(for: postID))
    }
}