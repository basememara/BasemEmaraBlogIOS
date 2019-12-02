//
//  ListFavoritesModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ListFavoritesModule: ListFavoritesModuleType {
    @Inject private var appModule: SwiftyPressCore
    @Inject private var sceneModule: SceneRenderType
    
    func component(with viewController: ListFavoritesDisplayable?) -> ListFavoritesActionable {
        ListFavoritesAction(
            presenter: component(with: viewController),
            postProvider: appModule.dependency(),
            mediaProvider: appModule.dependency()
        )
    }
    
    func component(with viewController: ListFavoritesDisplayable?) -> ListFavoritesPresentable {
        ListFavoritesPresenter(viewController: viewController)
    }
    
    func component(with viewController: UIViewController?) -> ListFavoritesRoutable {
        ListFavoritesRouter(
            viewController: viewController,
            scenes: sceneModule
        )
    }
    
    func component() -> ConstantsType {
        appModule.dependency()
    }
    
    func component() -> Theme {
        appModule.dependency()
    }
}
