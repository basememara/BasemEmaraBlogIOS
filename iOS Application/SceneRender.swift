//
//  SceneRender.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI
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

// MARK: - Conformance

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
        let presenter = MainPresenter { action in
            self.middleware.forEach { $0(action) }
            self.state.mainState.reduce(action)
        }
        
        let interactor = MainInteractor(presenter: presenter)
        let render = MainRender(render: self)
        let view: UIViewController
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            view = MainSplitViewController(render: render).apply {
                $0.viewControllers = [
                    UINavigationController(rootViewController: home()),
                    MainSplitDetailViewController(
                        state: state.mainState,
                        interactor: interactor,
                        render: render
                    )
                ]
            }
        default:
            view = MainViewController(
                state: state.mainState,
                interactor: interactor,
                render: render
            )
        }
        
        return view
    }
    
    @available(iOS 13, *)
    func launchMain<T: View>() -> T? {
        let presenter = MainPresenter { action in
            self.middleware.forEach { $0(action) }
            self.state.mainState.reduce(action)
        }
        
        let interactor = MainInteractor(presenter: presenter)
        let render = MainRender(render: self)
        
        // Unused until SwiftUI is more stable
        return MainView(
            state: state.mainState,
            interactor: interactor,
            render: render
        ) as? T
    }
}

extension SceneRender {
    
    func home() -> UIViewController {
        let presenter = HomePresenter { action in
            self.middleware.forEach { $0(action) }
            self.state.homeState.reduce(action)
        }
        
        let interactor = HomeInteractor(presenter: presenter)
        
        let render: (UIViewController) -> HomeRenderable = {
            HomeRender(
                render: self,
                mailComposer: self.core.mailComposer(),
                constants: self.core.constants(),
                theme: self.core.theme(),
                presentationContext: $0
            )
        }
        
        let view = HomeViewController(
            state: state.homeState,
            interactor: interactor,
            render: render
        )
        
        return view
    }
}

extension SceneRender {
    
    func showBlog() -> UIViewController {
        let presenter = ShowBlogPresenter { action in
            self.middleware.forEach { $0(action) }
            self.state.showBlogState.reduce(action)
        }
        
        let interactor = ShowBlogInteractor(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository(),
            taxonomyRepository: core.taxonomyRepository(),
            preferences: core.preferences()
        )
        
        let render: (UIViewController) -> ShowBlogRenderable = {
            ShowBlogRender(
                render: self,
                mailComposer: self.core.mailComposer(),
                theme: self.core.theme(),
                presentationContext: $0
            )
        }
        
        let view = ShowBlogViewController(
            state: state.showBlogState,
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
}

extension SceneRender {
    
    func listFavorites() -> UIViewController {
        let presenter = ListFavoritesPresenter { action in
            self.middleware.forEach { $0(action) }
            self.state.listFavoritesState.reduce(action)
        }
        
        let interactor = ListFavoritesInteractor(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository()
        )
        
        let render: (UIViewController) -> ListFavoritesRenderable = {
            ListFavoritesRender(
                render: self,
                presentationContext: $0
            )
        }
        
        let view = ListFavoritesViewController(
            state: state.listFavoritesState,
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
    
    func searchPosts() -> UIViewController {
        let presenter = SearchPostsPresenter { action in
            self.middleware.forEach { $0(action) }
            self.state.searchPostsState.reduce(action)
        }
        
        let interactor = SearchPostsInteractor(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository()
        )
        
        let render: (UIViewController) -> SearchPostsRenderable = {
            SearchPostsRender(
                render: self,
                presentationContext: $0
            )
        }
        
        let view = SearchPostsViewController(
            state: state.searchPostsState,
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
}

extension SceneRender {
    
    func listPosts(params: ListPostsAPI.Params, delegate: ListPostsDelegate?) -> UIViewController {
        let presenter = ListPostsPresenter { action in
            self.middleware.forEach { $0(action) }
            self.state.listPostsState.reduce(action)
        }
        
        let interactor = ListPostsInteractor(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository()
        )
        
        let render: (UIViewController) -> ListPostsRenderable = {
            ListPostsRender(
                render: self,
                presentationContext: $0,
                listPostsDelegate: nil
            )
        }
        
        let view = ListPostsViewController(
            state: state.listPostsState,
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        view.params = params
        view.delegate = delegate
        
        return view
    }
    
    func showPost(for id: Int) -> UIViewController {
        let presenter = ShowPostPresenter(
            dispatch: { action in
                self.middleware.forEach { $0(action) }
                self.state.showPostState.reduce(action)
            },
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
        
        let render: (UIViewController) -> ShowPostRenderable = {
            ShowPostRender(
                render: self,
                theme: self.core.theme(),
                presentationContext: $0,
                listPostsDelegate: $0 as? ListPostsDelegate
            )
        }
        
        let view = ShowPostViewController(
            state: state.showPostState,
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme(),
            application: .shared,
            notificationCenter: core.notificationCenter(),
            postID: id
        )
        
        return view
    }
    
    func listTerms() -> UIViewController {
        let presenter = ListTermsPresenter { action in
            self.middleware.forEach { $0(action) }
            self.state.listTermsState.reduce(action)
        }
        
        let interactor = ListTermsInteractor(
            presenter: presenter,
            taxonomyRepository: core.taxonomyRepository()
        )
        
        let render: (UIViewController) -> ListTermsRenderable = {
            ListTermsRender(
                render: self,
                presentationContext: $0
            )
        }
        
        let view = ListTermsViewController(
            state: state.listTermsState,
            interactor: interactor,
            render: render
        )
        
        return view
    }
}

extension SceneRender {
    
    func showMore() -> UIViewController {
        let presenter = ShowMorePresenter { action in
            self.middleware.forEach { $0(action) }
            self.state.showMoreState.reduce(action)
        }
        
        let interactor = ShowMoreInteractor(presenter: presenter)
        
        let render: (UIViewController) -> ShowMoreRenderable = {
            ShowMoreRender(
                render: self,
                constants: self.core.constants(),
                mailComposer: self.core.mailComposer(),
                theme: self.core.theme(),
                presentationContext: $0
            )
        }
        
        let view = ShowMoreViewController(
            state: state.showMoreState,
            interactor: interactor,
            render: render
        )
        
        return view
    }
    
    func showSettings() -> UIViewController {
        let presenter = ShowSettingsPresenter { action in
            self.middleware.forEach { $0(action) }
            self.state.showSettingsState.reduce(action)
        }
        
        let interactor = ShowSettingsInteractor(
            presenter: presenter,
            preferences: core.preferences()
        )
        
        let render = ShowSettingsRender(application: .shared)
        
        let view = ShowSettingsViewController(
            state: state.showSettingsState,
            interactor: interactor,
            render: render
        )
        
        return view
    }
}
