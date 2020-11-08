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
        let model = MainModel()
        let presenter = MainPresenter(model: model)
        let interactor = MainInteractor(presenter: presenter)
        let render = MainRender(render: self)
        let view: UIViewController
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            view = MainSplitViewController(render: render).apply {
                $0.viewControllers = [
                    UINavigationController(rootViewController: home()),
                    MainSplitDetailViewController(
                        model: model,
                        interactor: interactor,
                        render: render
                    )
                ]
            }
        default:
            view = MainViewController(
                model: model,
                interactor: interactor,
                render: render
            )
        }
        
        return view
    }
    
    @available(iOS 13, *)
    func launchMain<T: View>() -> T? {
        let model = MainModel()
        let presenter = MainPresenter(model: model)
        let interactor = MainInteractor(presenter: presenter)
        let render = MainRender(render: self)
        
        // Unused until SwiftUI is more stable
        return MainView(
            model: model,
            interactor: interactor,
            render: render
        ) as? T
    }
}

extension AppRender {
    
    func home() -> UIViewController {
        let model = HomeModel()
        let presenter = HomePresenter(model: model)
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
            model: model,
            interactor: interactor,
            render: render
        )
        
        return view
    }
}

extension AppRender {
    
    func showBlog() -> UIViewController {
        let model = ShowBlogModel()
        let presenter = ShowBlogPresenter(model: model)
        
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
            model: model,
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
}

extension AppRender {
    
    func listPosts(params: ListPostsAPI.Params, delegate: ListPostsDelegate? = nil) -> UIViewController {
        let model = ListPostsModel()
        let presenter = ListPostsPresenter(model: model)
        
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
            model: model,
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
        let model = ShowPostModel()
        
        let presenter = ShowPostPresenter(
            model,
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
            model: model,
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

extension AppRender {
    
    func listFavorites() -> UIViewController {
        let model = ListFavoritesModel()
        let presenter = ListFavoritesPresenter(model: model)
        
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
            model: model,
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
    
    func searchPosts() -> UIViewController {
        let model = SearchPostsModel()
        let presenter = SearchPostsPresenter(model: model)
        
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
            model: model,
            interactor: interactor,
            render: render,
            constants: core.constants(),
            theme: core.theme()
        )
        
        return view
    }
}

extension AppRender {
    
    func listTerms() -> UIViewController {
        let model = ListTermsModel()
        let presenter = ListTermsPresenter(model: model)
        
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
            model: model,
            interactor: interactor,
            render: render
        )
        
        return view
    }
}

extension AppRender {
    
    func showMore() -> UIViewController {
        let model = ShowMoreModel()
        let presenter = ShowMorePresenter(model: model)
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
            model: model,
            interactor: interactor,
            render: render
        )
        
        return view
    }
    
    func showSettings() -> UIViewController {
        let model = ShowSettingsModel()
        let presenter = ShowSettingsPresenter(model: model)
        
        let interactor = ShowSettingsInteractor(
            presenter: presenter,
            preferences: core.preferences()
        )
        
        let render = ShowSettingsRender(application: .shared)
        
        let view = ShowSettingsViewController(
            model: model,
            interactor: interactor,
            render: render
        )
        
        return view
    }
}
