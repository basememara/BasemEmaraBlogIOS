//
//  ListFavoritesModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress

struct ListFavoritesModule: ListFavoritesModuleType {
    
    func resolve(with viewController: ListFavoritesDisplayable?) -> ListFavoritesActionable {
        ListFavoritesAction(
            presenter: resolve(with: viewController),
            postWorker: resolve(),
            mediaWorker: resolve()
        )
    }
    
    func resolve(with viewController: ListFavoritesDisplayable?) -> ListFavoritesPresentable {
        ListFavoritesPresenter(viewController: viewController)
    }
    
    func resolve(with viewController: UIViewController?) -> ListFavoritesRoutable {
        ListFavoritesRouter(
            viewController: viewController,
            scenes: resolve()
        )
    }
}

extension ListFavoritesModule: Module {
    
    func register() {
        make { self as ListFavoritesModuleType }
    }
}
