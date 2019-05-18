//
//  SceneConfigurator.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct SceneConfigurator: SceneDependable {
    
    func startMain() -> UIViewController {
        return .make(fromStoryboard: Storyboard.main.rawValue)
    }
}

extension SceneConfigurator {
    
    func showDashboard() -> UIViewController {
        return .make(fromStoryboard: Storyboard.showDashboard.rawValue)
    }
    
    func listPosts(for fetchType: ListPostsViewController.FetchType, delegate: ShowPostViewControllerDelegate?) -> UIViewController {
        let controller: ListPostsViewController = .make(fromStoryboard: Storyboard.listPosts.rawValue)
        controller.fetchType = fetchType
        controller.delegate = delegate
        return controller
    }
    
    func showPost(for id: Int) -> UIViewController {
        let controller: ShowPostViewController = .make(fromStoryboard: Storyboard.showPost.rawValue)
        controller.postID = id
        return controller
    }
    
    func previewPost(for model: PostsDataViewModel, delegate: UIViewController?) -> UIViewController {
        let controller: PreviewPostViewController = .make(fromStoryboard: Storyboard.previewPost.rawValue)
        controller.viewModel = model
        controller.delegate = delegate
        return controller
    }
    
    func listTerms() -> UIViewController {
        return .make(fromStoryboard: Storyboard.listTerms.rawValue)
    }
    
    func showSettings() -> UIViewController {
        return .make(fromStoryboard: Storyboard.showSettings.rawValue)
    }
}

extension SceneConfigurator {
    
    /// Tab identifiers for routing
    enum Tab: Int {
        case dashboard = 0
        case favorites = 1
        case search = 2
        case more = 3
    }
    
    /// Storyboard identifiers for routing
    enum Storyboard: String {
        case main = "Main"
        case showDashboard = "ShowDashboard"
        case listPosts = "ListPosts"
        case showPost = "ShowPost"
        case previewPost = "PreviewPost"
        case listTerms = "ListTerms"
        case showSettings = "ShowSettings"
    }
}
