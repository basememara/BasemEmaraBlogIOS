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
    
    func action(with viewController: ShowBlogDisplayable?) -> ShowBlogActionable {
        ShowBlogAction(
            presenter: presenter(with: viewController),
            postRepository: root.postRepository(),
            mediaRepository: root.mediaRepository(),
            taxonomyRepository: root.taxonomyRepository(),
            preferences: root.preferences()
        )
    }
    
    func presenter(with viewController: ShowBlogDisplayable?) -> ShowBlogPresentable {
        ShowBlogPresenter(viewController: viewController)
    }
    
    func router(with viewController: UIViewController?) -> ShowBlogRouterable {
        ShowBlogRouter(
            render: render,
            mailComposer: root.mailComposer(),
            theme: root.theme(),
            viewController: viewController
        )
    }
    
    func constants() -> ConstantsType {
        root.constants()
    }
    
    func theme() -> Theme {
        root.theme()
    }
    
    func mailComposer() -> MailComposerType {
        root.mailComposer()
    }
}
