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
protocol SceneRenderable {
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

extension SceneRenderable {
    
    func listPosts(params: ListPostsAPI.Params) -> UIViewController {
        listPosts(params: params, delegate: nil)
    }
}

struct SceneRender: SceneRenderable {
    private let core: SwiftyPressCore
    private let state: AppState
    private let middleware: [Middleware]
    
    init(core: SwiftyPressCore, state: AppState, middleware: [Middleware]) {
        self.core = core
        self.state = state
        self.middleware = middleware
    }
}

// MARK: - Scenes

extension SceneRender {
    
    func launchMain() -> UIViewController {
        let store = Store(keyPath: \.mainState, with: middleware)
        let presenter = MainPresenter(store: store)
        let interactor = MainInteractor(presenter: presenter)
        let render = MainRender(render: self)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return MainSplitViewController(render: render).apply {
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
        let presenter = MainPresenter(store: store)
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
        let presenter = HomePresenter(store: store)
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
        let presenter = ShowBlogPresenter(store: store)
        
        let interactor = ShowBlogInteractor(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository(),
            taxonomyRepository: core.taxonomyRepository(),
            preferences: core.preferences()
        )
        
        let controller = ShowBlogViewController(
            store: store,
            interactor: interactor,
            constants: core.constants(),
            theme: core.theme()
        )
        
        controller.render = ShowBlogRender(
            render: self,
            mailComposer: core.mailComposer(),
            theme: core.theme(),
            presentationContext: controller
        )
        
        return controller
    }
}

extension SceneRender {
    
    func listFavorites() -> UIViewController {
        let store = Store(keyPath: \.listFavoritesState)
        let presenter = ListFavoritesPresenter(store: store)
        
        let interactor = ListFavoritesInteractor(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository()
        )
        
        let controller = ListFavoritesViewController(
            store: store,
            interactor: interactor,
            constants: core.constants(),
            theme: core.theme()
        )
        
        controller.render = ListFavoritesRender(
            render: self,
            presentationContext: controller
        )
        
        return controller
    }
    
    func searchPosts() -> UIViewController {
        let store = Store(keyPath: \.searchPostsState)
        let presenter = SearchPostsPresenter(store: store)
        
        let interactor = SearchPostsInteractor(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository()
        )
        
        let controller = SearchPostsViewController(
            store: store,
            interactor: interactor,
            constants: core.constants(),
            theme: core.theme()
        )
        
        controller.render = SearchPostsRender(
            render: self,
            presentationContext: controller
        )
        
        return controller
    }
}

extension SceneRender {
    
    func listPosts(params: ListPostsAPI.Params, delegate: ListPostsDelegate?) -> UIViewController {
        let store = Store(keyPath: \.listPostsState)
        let presenter = ListPostsPresenter(store: store)
        
        let interactor = ListPostsInteractor(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository()
        )
        
        let controller = ListPostsViewController(
            store: store,
            interactor: interactor,
            constants: core.constants(),
            theme: core.theme()
        )
        
        controller.render = ListPostsRender(
            render: self,
            presentationContext: controller,
            listPostsDelegate: nil
        )
        
        controller.params = params
        controller.delegate = delegate
        
        return controller
    }
    
    func showPost(for id: Int) -> UIViewController {
        let store = Store(keyPath: \.showPostState)
        
        let presenter = ShowPostPresenter(
            store: store,
            constants: core.constants(),
            templateFile: Bundle.main.string(file: "post.html"),
            styleSheetFile: Bundle.main.string(file: "style.css")
        )
        
        let interactor = ShowPostInteractor(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository(),
            authorRepository: core.authorRepository(),
            taxonomyRepository: core.taxonomyRepository()
        )
        
        let controller = ShowPostViewController(
            store: store,
            interactor: interactor,
            constants: core.constants(),
            theme: core.theme(),
            application: .shared,
            notificationCenter: core.notificationCenter(),
            postID: id
        )
        
        controller.render = ShowPostRender(
            render: self,
            theme: core.theme(),
            presentationContext: controller,
            listPostsDelegate: controller
        )
        
        return controller
    }
    
    func listTerms() -> UIViewController {
        let store = Store(keyPath: \.listTermsState)
        let presenter = ListTermsPresenter(store: store)
        
        let interactor = ListTermsInteractor(
            presenter: presenter,
            taxonomyRepository: core.taxonomyRepository()
        )
        
        let controller = ListTermsViewController(
            store: store,
            interactor: interactor
        )
        
        controller.render = ListTermsRender(
            render: self,
            presentationContext: controller
        )
        
        return controller
    }
}

extension SceneRender {
    
    func showMore() -> UIViewController {
        let store = Store(keyPath: \.showMoreState)
        let presenter = ShowMorePresenter(store: store)
        let interactor = ShowMoreInteractor(presenter: presenter)
        let controller = ShowMoreViewController(store: store, interactor: interactor)
        
        controller.render = ShowMoreRender(
            render: self,
            constants: core.constants(),
            mailComposer: core.mailComposer(),
            theme: core.theme(),
            presentationContext: controller
        )
        
        return controller
    }
    
    func showSettings() -> UIViewController {
        let store = Store(keyPath: \.showSettingsState)
        let presenter = ShowSettingsPresenter(store: store)
        let render = ShowSettingsRender(application: .shared)
        
        let interactor = ShowSettingsInteractor(
            presenter: presenter,
            preferences: core.preferences()
        )
        
        let controller = ShowSettingsViewController(
            store: store,
            interactor: interactor,
            render: render
        )
        
        return controller
    }
}
