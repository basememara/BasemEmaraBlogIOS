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
    private let core: SwiftyPressCore
    private let render: SceneRenderType
    
    init(core: SwiftyPressCore, render: SceneRenderType) {
        self.core = core
        self.render = render
    }
    
    func dependency(with viewController: ShowBlogDisplayable?) -> ShowBlogActionable {
        ShowBlogAction(
            presenter: dependency(with: viewController),
            postProvider: core.dependency(),
            mediaProvider: core.dependency(),
            taxonomyProvider: core.dependency(),
            preferences: core.dependency()
        )
    }
    
    func dependency(with viewController: ShowBlogDisplayable?) -> ShowBlogPresentable {
        ShowBlogPresenter(viewController: viewController)
    }
    
    func dependency(with viewController: UIViewController?) -> ShowBlogRenderable {
        ShowBlogRender(
            viewController: viewController,
            scenes: render
        )
    }
    
    func dependency() -> ConstantsType {
        core.dependency()
    }
    
    func dependency() -> Theme {
        core.dependency()
    }
    
    func dependency() -> MailComposerType {
        core.dependency()
    }
}
