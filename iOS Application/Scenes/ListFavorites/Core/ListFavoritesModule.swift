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
    @Inject private var appModule: SwiftyPressModule
    @Inject private var sceneModule: SceneModuleType
    
    func component(with viewController: ListFavoritesDisplayable?) -> ListFavoritesActionable {
        ListFavoritesAction(
            presenter: component(with: viewController),
            postProvider: appModule.component(),
            mediaProvider: appModule.component()
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
        appModule.component()
    }
    
    func component() -> Theme {
        appModule.component()
    }
}
