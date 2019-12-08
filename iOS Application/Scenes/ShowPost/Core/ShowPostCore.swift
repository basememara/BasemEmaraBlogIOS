//
//  ShowPostCore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ShowPostCore: ShowPostCoreType {
    private let core: SwiftyPressCore
    private let render: SceneRenderType
    
    init(core: SwiftyPressCore, render: SceneRenderType) {
        self.core = core
        self.render = render
    }
    
    func dependency(with viewController: ShowPostDisplayable?) -> ShowPostActionable {
        ShowPostAction(
            presenter: dependency(with: viewController),
            postProvider: core.dependency(),
            mediaProvider: core.dependency(),
            authorProvider: core.dependency(),
            taxonomyProvider: core.dependency()
        )
    }
    
    func dependency(with viewController: ShowPostDisplayable?) -> ShowPostPresentable {
        ShowPostPresenter(
            viewController: viewController,
            constants: core.dependency()
        )
    }
    
    func dependency(with inputs: ShowPostAPI.RoutableInputs) -> ShowPostRenderable {
        ShowPostRender(
            render: render,
            viewController: inputs.viewController,
            listPostsDelegate: inputs.listPostsDelegate
        )
    }
    
    func dependency() -> NotificationCenter {
        core.dependency()
    }
    
    func dependency() -> ConstantsType {
        core.dependency()
    }
    
    func dependency() -> Theme {
        core.dependency()
    }
}
