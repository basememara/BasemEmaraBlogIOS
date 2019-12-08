//
//  ListPostsCore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ListPostsCore: ListPostsCoreType {
    private let core: SwiftyPressCore
    private let render: SceneRenderType
    
    init(core: SwiftyPressCore, render: SceneRenderType) {
        self.core = core
        self.render = render
    }
    
    func dependency(with viewController: ListPostsDisplayable?) -> ListPostsActionable {
        ListPostsAction(
            presenter: dependency(with: viewController),
            postProvider: core.dependency(),
            mediaProvider: core.dependency()
        )
    }
    
    func dependency(with viewController: ListPostsDisplayable?) -> ListPostsPresentable {
        ListPostsPresenter(viewController: viewController)
    }
    
    func dependency(with viewController: UIViewController?) -> ListPostsRenderable {
        ListPostsRender(
            render: render,
            viewController: viewController
        )
    }
    
    func dependency() -> ConstantsType {
        core.dependency()
    }
    
    func dependency() -> Theme {
        core.dependency()
    }
}
