//
//  SceneRender.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

/// Dependency injector for overriding concrete scene factories.
protocol SceneRenderType {
    func launchMain() -> UIViewController
    
    func home() -> UIViewController
    func listFavorites() -> UIViewController
    func searchPosts() -> UIViewController
    
    func showBlog() -> UIViewController
    func listPosts(params: ListPostsAPI.Params, delegate: ListPostsDelegate?) -> UIViewController
    func showPost(for id: Int) -> UIViewController
    func listTerms() -> UIViewController
    
    func showMore() -> UIViewController
    func showSettings() -> UIViewController
}

extension SceneRenderType {
    
    func listPosts(params: ListPostsAPI.Params) -> UIViewController {
        listPosts(params: params, delegate: nil)
    }
}

struct SceneRender: SceneRenderType {
    private let core: SwiftyPressCore
    private let state: AppState
    private let middleware: [MiddlewareType]
    
    init(core: SwiftyPressCore, state: AppState, middleware: [MiddlewareType]) {
        self.core = core
        self.state = state
        self.middleware = middleware
    }
}

// MARK: - Scenes

extension SceneRender {
    
    func launchMain() -> UIViewController {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return MainSplitViewController(
                router: MainRouter(render: self)
            )
            .with {
                $0.viewControllers = [
                    UINavigationController(rootViewController: home()),
                    MainSplitDetailViewController(
                        model: state.main ?? MainModel(
                            menu: [],
                            layout: .pad
                        ),
                        action: MainActionCreator(
                            render: self,
                            dispatch: action(to: MainReducer())
                        )
                    )
                ]
            }
        default:
            return MainViewController(
                model: state.main ?? MainModel(
                    menu: [],
                    layout: .phone
                ),
                action: MainActionCreator(
                    render: self,
                    dispatch: action(to: MainReducer())
                )
            )
        }
    }
}

extension SceneRender {
    
    func home() -> UIViewController {
        let controller: HomeViewController = .make(fromStoryboard: Storyboard.home.rawValue)
        controller.core = HomeCore(root: core, render: self)
        return controller
    }
    
    func listFavorites() -> UIViewController {
        let controller: ListFavoritesViewController = .make(fromStoryboard: Storyboard.listFavorites.rawValue)
        controller.core = ListFavoritesCore(root: core, render: self)
        return controller
    }
    
    func searchPosts() -> UIViewController {
        let controller: SearchPostsViewController = .make(fromStoryboard: Storyboard.searchPosts.rawValue)
        controller.core = SearchPostsCore(root: core, render: self)
        return controller
    }
}

extension SceneRender {
    
    func showBlog() -> UIViewController {
        let controller: ShowBlogViewController = .make(fromStoryboard: Storyboard.showBlog.rawValue)
        controller.core = ShowBlogCore(root: core, render: self)
        return controller
    }
    
    func listPosts(params: ListPostsAPI.Params, delegate: ListPostsDelegate?) -> UIViewController {
        let controller: ListPostsViewController = .make(fromStoryboard: Storyboard.listPosts.rawValue)
        controller.core = ListPostsCore(root: core, render: self)
        controller.params = params
        controller.delegate = delegate
        return controller
    }
    
    func showPost(for id: Int) -> UIViewController {
        let controller: ShowPostViewController = .make(fromStoryboard: Storyboard.showPost.rawValue)
        controller.core = ShowPostCore(root: core, render: self)
        controller.postID = id
        return controller
    }
    
    func listTerms() -> UIViewController {
        let controller: ListTermsViewController = .make(fromStoryboard: Storyboard.listTerms.rawValue)
        controller.core = ListTermsCore(root: core, render: self)
        return controller
    }
}

extension SceneRender {
    
    func showMore() -> UIViewController {
        let controller: ShowMoreViewController = .make(fromStoryboard: Storyboard.showMore.rawValue)
        controller.core = ShowMoreCore(root: core, render: self)
        return controller
    }
    
    func showSettings() -> UIViewController {
        let controller: ShowSettingsViewController = .make(fromStoryboard: Storyboard.showSettings.rawValue)
        controller.preferences = core.dependency()
        return controller
    }
}

private extension SceneRender {
    
    /// Creates action closure for the view to send to the reducer. This separation decouples actions and reducers.
    func action<Action, Reducer>(to reducer: Reducer) -> (Action) -> Void
        where Reducer: ReducerType, Reducer.Action == Action {
            return { action in
                // Allow middleware to passively execute against action
                self.middleware.forEach { $0.execute(on: action) }
                
                // Mutate the state for the action
                reducer.reduce(self.state, action)
            }
    }
}

// MARK: - Subtypes

extension SceneRender {
    
    /// Menu identifiers for routing
    enum Menu: Int {
        case home = 0
        case blog = 1
        case favorites = 2
        case search = 3
        case more = 4
    }
    
    /// Storyboard identifiers for routing
    enum Storyboard: String {
        case home = "Home"
        case listFavorites = "ListFavorites"
        case searchPosts = "SearchPosts"
        
        case showBlog = "ShowBlog"
        case listPosts = "ListPosts"
        case showPost = "ShowPost"
        case listTerms = "ListTerms"
        
        case showMore = "ShowMore"
        case showSettings = "ShowSettings"
    }
}
