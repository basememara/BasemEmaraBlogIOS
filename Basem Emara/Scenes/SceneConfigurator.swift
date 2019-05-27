//
//  SceneConfigurator.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

/// Dependency injector for overriding concrete scene factories.
/// Inject delegates, parameters, interactors, presenters, routers,
/// and so forth to override behavior in the next scene.
protocol SceneDependable {
    func startMain() -> UIViewController
    func startBlog() -> UIViewController
    func showBlog() -> UIViewController
    func listPosts(params: ListPostsModels.Params, delegate: ShowPostViewControllerDelegate?) -> UIViewController
    func showPost(for id: Int) -> UIViewController
    func previewPost(for model: PostsDataViewModel, delegate: UIViewController?) -> UIViewController
    func listTerms() -> UIViewController
    func showSettings() -> UIViewController
}

extension SceneDependable {
    
    func listPosts(params: ListPostsModels.Params) -> UIViewController {
        return listPosts(params: params, delegate: nil)
    }
}

struct SceneConfigurator: SceneDependable {
    
    func startMain() -> UIViewController {
        return .make(fromStoryboard: Storyboard.main.rawValue)
    }
    
    func startBlog() -> UIViewController {
        return .make(fromStoryboard: Storyboard.blog.rawValue)
    }
}

extension SceneConfigurator {
    
    func showBlog() -> UIViewController {
        return .make(fromStoryboard: Storyboard.showBlog.rawValue)
    }
    
    func listPosts(params: ListPostsModels.Params, delegate: ShowPostViewControllerDelegate?) -> UIViewController {
        let controller: ListPostsViewController = .make(fromStoryboard: Storyboard.listPosts.rawValue)
        controller.params = params
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
        case blog = "Blog"
        case showBlog = "ShowBlog"
        case listPosts = "ListPosts"
        case showPost = "ShowPost"
        case previewPost = "PreviewPost"
        case listTerms = "ListTerms"
        case showSettings = "ShowSettings"
    }
}
