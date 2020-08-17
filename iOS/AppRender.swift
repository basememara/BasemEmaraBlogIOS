//
//  AppRender.swift
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

struct AppRender {
    private let core: SwiftyPressCore
    private let store: AppStore
    
    init(core: SwiftyPressCore, store: AppStore) {
        self.core = core
        self.store = store
    }
}

// MARK: - Scenes

extension AppRender {
    
    func launchMain() -> UIViewController {
        let state = MainState()
        let presenter = MainPresenter { state($0) }
        let action = MainAction(presenter: presenter)
        let render = MainRender(render: self)
        let view: UIViewController
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            view = MainSplitViewController(render: render).apply {
                $0.viewControllers = [
                    UINavigationController(rootViewController: home()),
                    MainSplitDetailViewController(
                        state: state,
                        action: action,
                        render: render
                    )
                ]
            }
        default:
            view = MainViewController(
                state: state,
                action: action,
                render: render
            )
        }
        
        return view
    }
    
    @available(iOS 13, *)
    func launchMain<T: View>() -> T? {
        let state = MainState()
        let presenter = MainPresenter { state($0) }
        let action = MainAction(presenter: presenter)
        let render = MainRender(render: self)
        
        // Unused until SwiftUI is more stable
        return MainView(
            state: state,
            action: action,
            render: render
        ) as? T
    }
}

extension AppRender {
    
    func home() -> UIViewController {
        let state = HomeState()
        let presenter = HomePresenter { state($0) }
        let action = HomeAction(presenter: presenter)
        
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
            state: state,
            action: action,
            render: render
        )
        
        return view
    }
}

extension AppRender {
    
    func showBlog() -> UIViewController {
        let state = ShowBlogState(
            postsState: store.postsState,
            termsState: store.termsState
        )
        
        let presenter = ShowBlogPresenter { state($0) }
        
        let action = ShowBlogAction(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository(),
            taxonomyRepository: core.taxonomyRepository(),
            favoriteRepository: core.favoriteRepository(),
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
            state: state,
            action: action,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
}

extension AppRender {
    
    func listPosts(params: ListPostsAPI.Params, delegate: ListPostsDelegate? = nil) -> UIViewController {
        let state = ListPostsState(postsState: store.postsState)
        let presenter = ListPostsPresenter { state($0) }
        
        let action = ListPostsAction(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository(),
            favoriteRepository: core.favoriteRepository()
        )
        
        let render: (UIViewController) -> ListPostsRenderable = {
            ListPostsRender(
                render: self,
                presentationContext: $0,
                listPostsDelegate: nil
            )
        }
        
        let view = ListPostsViewController(
            state: state,
            action: action,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        view.params = params
        view.delegate = delegate
        
        return view
    }
    
    func showPost(for id: Int) -> UIViewController {
        let state = ShowPostState(postsState: store.postsState)
        
        let presenter = ShowPostPresenter(
            state: { state($0) },
            constants: core.constants(),
            templateFile: Bundle.main.string(file: "post.html"),
            styleSheetFile: Bundle.main.string(file: "style.css")
        )
        
        let action = ShowPostAction(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository(),
            authorRepository: core.authorRepository(),
            taxonomyRepository: core.taxonomyRepository(),
            favoriteRepository: core.favoriteRepository()
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
            state: state,
            action: action,
            render: render,
            constants: core.constants(),
            theme: core.theme(),
            application: .shared,
            notificationCenter: core.notificationCenter(),
            postID: id
        )
        
        return view
    }
}

extension AppRender {
    
    func listFavorites() -> UIViewController {
        let state = ListFavoritesState(postsState: store.postsState)
        let presenter = ListFavoritesPresenter { state($0) }
        
        let action = ListFavoritesAction(
            presenter: presenter,
            favoriteRepository: core.favoriteRepository(),
            mediaRepository: core.mediaRepository()
        )
        
        let render: (UIViewController) -> ListFavoritesRenderable = {
            ListFavoritesRender(
                render: self,
                presentationContext: $0
            )
        }
        
        let view = ListFavoritesViewController(
            state: state,
            action: action,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
    
    func searchPosts() -> UIViewController {
        let state = SearchPostsState()
        let presenter = SearchPostsPresenter { state($0) }
        
        let action = SearchPostsAction(
            presenter: presenter,
            postRepository: core.postRepository(),
            mediaRepository: core.mediaRepository(),
            favoriteRepository: core.favoriteRepository()
        )
        
        let render: (UIViewController) -> SearchPostsRenderable = {
            SearchPostsRender(
                render: self,
                presentationContext: $0
            )
        }
        
        let view = SearchPostsViewController(
            state: state,
            action: action,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
}

extension AppRender {
    
    func listTerms() -> UIViewController {
        let state = ListTermsState()
        let presenter = ListTermsPresenter { state($0) }
        
        let action = ListTermsAction(
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
            state: state,
            action: action,
            render: render
        )
        
        return view
    }
}

extension AppRender {
    
    func showMore() -> UIViewController {
        let state = ShowMoreState()
        let presenter = ShowMorePresenter { state($0) }
        let action = ShowMoreAction(presenter: presenter)
        
        let render: (UIViewController & Refreshable) -> ShowMoreRenderable = {
            ShowMoreRender(
                render: self,
                constants: self.core.constants(),
                mailComposer: self.core.mailComposer(),
                theme: self.core.theme(),
                presentationContext: $0
            )
        }
        
        let view = ShowMoreViewController(
            state: state,
            action: action,
            render: render
        )
        
        return view
    }
    
    func showSettings() -> UIViewController {
        let state = ShowSettingsState()
        let presenter = ShowSettingsPresenter { state($0) }
        
        let action = ShowSettingsAction(
            presenter: presenter,
            preferences: core.preferences()
        )
        
        let render = ShowSettingsRender(application: .shared)
        
        let view = ShowSettingsViewController(
            state: state,
            action: action,
            render: render
        )
        
        return view
    }
}
