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
    private let root: SwiftyPressCore
    private let render: SceneRenderType
    
    init(root: SwiftyPressCore, render: SceneRenderType) {
        self.root = root
        self.render = render
    }
    
    func dependency(with viewController: ShowPostDisplayable?) -> ShowPostActionable {
        ShowPostAction(
            presenter: dependency(with: viewController),
            postProvider: root.dependency(),
            mediaProvider: root.dependency(),
            authorProvider: root.dependency(),
            taxonomyProvider: root.dependency()
        )
    }
    
    func dependency(with viewController: ShowPostDisplayable?) -> ShowPostPresentable {
        ShowPostPresenter(
            viewController: viewController,
            constants: root.dependency()
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
        root.dependency()
    }
    
    func dependency() -> ConstantsType {
        root.dependency()
    }
    
    func dependency() -> Theme {
        root.dependency()
    }
}
