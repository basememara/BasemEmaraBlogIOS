//
//  ListFavoritesCore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ListFavoritesCore: ListFavoritesCoreType {
    private let root: SwiftyPressCore
    private let render: SceneRenderType
    
    init(root: SwiftyPressCore, render: SceneRenderType) {
        self.root = root
        self.render = render
    }
    
    func dependency(with viewController: ListFavoritesDisplayable?) -> ListFavoritesActionable {
        ListFavoritesAction(
            presenter: dependency(with: viewController),
            postProvider: root.dependency(),
            mediaProvider: root.dependency()
        )
    }
    
    func dependency(with viewController: ListFavoritesDisplayable?) -> ListFavoritesPresentable {
        ListFavoritesPresenter(viewController: viewController)
    }
    
    func dependency(with viewController: UIViewController?) -> ListFavoritesRouterable {
        ListFavoritesRouter(
            render: render,
            viewController: viewController
        )
    }
    
    func dependency() -> ConstantsType {
        root.dependency()
    }
    
    func dependency() -> Theme {
        root.dependency()
    }
}
