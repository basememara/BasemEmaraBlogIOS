//
//  ShowBlogCore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

struct ShowBlogCore: ShowBlogCoreType {
    private let root: SwiftyPressCore
    private let render: SceneRenderType
    
    init(root: SwiftyPressCore, render: SceneRenderType) {
        self.root = root
        self.render = render
    }
    
    func dependency(with viewController: ShowBlogDisplayable?) -> ShowBlogActionable {
        ShowBlogAction(
            presenter: dependency(with: viewController),
            postProvider: root.dependency(),
            mediaProvider: root.dependency(),
            taxonomyProvider: root.dependency(),
            preferences: root.dependency()
        )
    }
    
    func dependency(with viewController: ShowBlogDisplayable?) -> ShowBlogPresentable {
        ShowBlogPresenter(viewController: viewController)
    }
    
    func dependency(with viewController: UIViewController?) -> ShowBlogRenderable {
        ShowBlogRender(
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
    
    func dependency() -> MailComposerType {
        root.dependency()
    }
}
