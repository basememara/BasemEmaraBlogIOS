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

struct SceneRender {
    private let core: SwiftyPressCore
    private let state: AppState
    
    init(core: SwiftyPressCore, state: AppState) {
        self.core = core
        self.state = state
    }
}

// MARK: - Scenes

extension SceneRender {
    
    func launchMain() -> UIViewController {
        let presenter = MainPresenter { self.state.mainState($0) }
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
        let presenter = MainPresenter { self.state.mainState($0) }
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
        let presenter = HomePresenter { self.state.homeState($0) }
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
        let presenter = ShowBlogPresenter { self.state.showBlogState($0) }
        
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
    
    func listPosts(params: ListPostsAPI.Params, delegate: ListPostsDelegate? = nil) -> UIViewController {
        let presenter = ListPostsPresenter { self.state.listPostsState($0) }
        
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
            state: { self.state.showPostState($0) },
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
}

extension SceneRender {
    
    func listFavorites() -> UIViewController {
        let presenter = ListFavoritesPresenter { self.state.listFavoritesState($0) }
        
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
        let presenter = SearchPostsPresenter { self.state.searchPostsState($0) }
        
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
    
    func listTerms() -> UIViewController {
        let presenter = ListTermsPresenter { self.state.listTermsState($0) }
        
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
        let presenter = ShowMorePresenter { self.state.showMoreState($0) }
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
        let presenter = ShowSettingsPresenter { self.state.showSettingsState($0) }
        
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
