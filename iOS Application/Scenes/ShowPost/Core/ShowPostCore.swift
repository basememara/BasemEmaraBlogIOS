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
    
    func action(with viewController: ShowPostDisplayable?) -> ShowPostActionable {
        ShowPostAction(
            presenter: presenter(with: viewController),
            postRepository: root.postRepository(),
            mediaRepository: root.mediaRepository(),
            authorRepository: root.authorRepository(),
            taxonomyRepository: root.taxonomyRepository()
        )
    }
    
    func presenter(with viewController: ShowPostDisplayable?) -> ShowPostPresentable {
        ShowPostPresenter(
            viewController: viewController,
            constants: root.constants()
        )
    }
    
    func router(
        viewController: UIViewController?,
        listPostsDelegate: ListPostsDelegate?
    ) -> ShowPostRouterable {
        ShowPostRouter(
            render: render,
            theme: root.theme(),
            viewController: viewController,
            listPostsDelegate: listPostsDelegate
        )
    }
    
    func notificationCenter() -> NotificationCenter {
        root.notificationCenter()
    }
    
    func constants() -> ConstantsType {
        root.constants()
    }
    
    func theme() -> Theme {
        root.theme()
    }
}
