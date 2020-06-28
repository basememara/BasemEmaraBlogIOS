//
//  ViewRender.swift
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

struct ViewRender {
    private let core: SwiftyPressCore
    private let state: AppState
    
    init(core: SwiftyPressCore, state: AppState) {
        self.core = core
        self.state = state
    }
}

// MARK: - Scenes

extension ViewRender {
    
    func launchMain() -> UIViewController {
        let state = MainState()
        let presenter = MainPresenter { state($0) }
        let interactor = MainInteractor(presenter: presenter)
        let render = MainRender(render: self)
        let view: UIViewController
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            view = MainSplitViewController(render: render).apply {
                $0.viewControllers = [
                    UINavigationController(rootViewController: home()),
                    MainSplitDetailViewController(
                        state: state,
                        interactor: interactor,
                        render: render
                    )
                ]
            }
        default:
            view = MainViewController(
                state: state,
                interactor: interactor,
                render: render
            )
        }
        
        return view
    }
    
    @available(iOS 13, *)
    func launchMain<T: View>() -> T? {
        let state = MainState()
        let presenter = MainPresenter { state($0) }
        let interactor = MainInteractor(presenter: presenter)
        let render = MainRender(render: self)
        
        // Unused until SwiftUI is more stable
        return MainView(
            state: state,
            interactor: interactor,
            render: render
        ) as? T
    }
}

extension ViewRender {
    
    func home() -> UIViewController {
        let state = HomeState()
        let presenter = HomePresenter { state($0) }
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
            state: state,
            interactor: interactor,
            render: render
        )
        
        return view
    }
}

extension ViewRender {
    
    func showBlog() -> UIViewController {
        let state = ShowBlogState(
            postsState: self.state.postsState,
            termsState: self.state.termsState
        )
        
        let presenter = ShowBlogPresenter { state($0) }
        
        let interactor = ShowBlogInteractor(
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
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
}

extension ViewRender {
    
    func listPosts(params: ListPostsAPI.Params, delegate: ListPostsDelegate? = nil) -> UIViewController {
        let state = ListPostsState(postsState: self.state.postsState)
        let presenter = ListPostsPresenter { state($0) }
        
        let interactor = ListPostsInteractor(
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
        let state = ShowPostState(postsState: self.state.postsState)
        
        let presenter = ShowPostPresenter(
            state: { state($0) },
            constants: core.constants(),
            templateFile: Bundle.main.string(file: "post.html"),
            styleSheetFile: Bundle.main.string(file: "style.css")
        )
        
        let interactor = ShowPostInteractor(
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
}

extension ViewRender {
    
    func listFavorites() -> UIViewController {
        let state = ListFavoritesState(postsState: self.state.postsState)
        let presenter = ListFavoritesPresenter { state($0) }
        
        let interactor = ListFavoritesInteractor(
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
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
    
    func searchPosts() -> UIViewController {
        let state = SearchPostsState()
        let presenter = SearchPostsPresenter { state($0) }
        
        let interactor = SearchPostsInteractor(
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
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
}

extension ViewRender {
    
    func listTerms() -> UIViewController {
        let state = ListTermsState()
        let presenter = ListTermsPresenter { state($0) }
        
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
            state: state,
            interactor: interactor,
            render: render
        )
        
        return view
    }
}

extension ViewRender {
    
    func showMore() -> UIViewController {
        let state = ShowMoreState()
        let presenter = ShowMorePresenter { state($0) }
        let interactor = ShowMoreInteractor(presenter: presenter)
        
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
            interactor: interactor,
            render: render
        )
        
        return view
    }
    
    func showSettings() -> UIViewController {
        let state = ShowSettingsState()
        let presenter = ShowSettingsPresenter { state($0) }
        
        let interactor = ShowSettingsInteractor(
            presenter: presenter,
            preferences: core.preferences()
        )
        
        let render = ShowSettingsRender(application: .shared)
        
        let view = ShowSettingsViewController(
            state: state,
            interactor: interactor,
            render: render
        )
        
        return view
    }
}
