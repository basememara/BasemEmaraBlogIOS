//
//  SceneRender.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
#if canImport(SwiftUI)
import SwiftUI
#endif

/// Dependency injector for overriding concrete scene factories.
protocol SceneRenderType {
    func launchMain() -> UIViewController
    
    @available(iOS 13, *)
    func launchMain<T: View>() -> T?
    
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
        let store = Store(keyPath: \.mainState, with: middleware)
        let presenter = MainPresenter(send: store.send)
        let interactor = MainInteractor(presenter: presenter)
        let render = MainRender(render: self)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return MainSplitViewController(render: render).with {
                $0.viewControllers = [
                    UINavigationController(rootViewController: home()),
                    MainSplitDetailViewController(
                        store: store,
                        interactor: interactor,
                        render: render
                    )
                ]
            }
        default:
            return MainViewController(
                store: store,
                interactor: interactor,
                render: render
            )
        }
    }
    
    @available(iOS 13, *)
    func launchMain<T: View>() -> T? {
        let store = Store(keyPath: \.mainState, with: middleware)
        let presenter = MainPresenter(send: store.send)
        let interactor = MainInteractor(presenter: presenter)
        let render = MainRender(render: self)
        
        // Unused until SwiftUI is more stable
        return MainView(
            store: store,
            interactor: interactor,
            render: render
        ) as? T
    }
}

extension SceneRender {
    
    func home() -> UIViewController {
        let store = Store(keyPath: \.homeState)
        let presenter = HomePresenter(send: store.send)
        let interactor = HomeInteractor(presenter: presenter)
        let controller = HomeViewController(store: store, interactor: interactor)
        
        controller.render = HomeRender(
            render: self,
            mailComposer: core.mailComposer(),
            constants: core.constants(),
            theme: core.theme(),
            presentationContext: controller
        )
        
        return controller
    }
}

extension SceneRender {
    
    func showBlog() -> UIViewController {
        let store = Store(keyPath: \.showBlogState)
        let presenter = ShowBlogPresenter(send: store.send)
        
        let interactor = ShowBlogInteractor(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository(),
            taxonomyRepository: core.taxonomyRepository(),
            preferences: core.preferences()
        )
        
        let controller: ShowBlogViewController = .make(fromStoryboard: Storyboard.showBlog.rawValue)
        
        controller.store = store
        controller.interactor = interactor
        
        controller.render = ShowBlogRender(
            render: self,
            mailComposer: core.mailComposer(),
            theme: core.theme(),
            presentationContext: controller
        )
        
        controller.constants = core.constants()
        controller.theme = core.theme()
        
        return controller
    }
}

extension SceneRender {
    
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
        controller.preferences = core.preferences()
        return controller
    }
}

// MARK: - Subtypes

extension SceneRender {
    
    /// Storyboard identifiers for routing.
    enum Storyboard: String {
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
