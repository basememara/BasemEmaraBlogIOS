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
    private let root: SwiftyPressCore
    private let render: SceneRenderType
    
    init(root: SwiftyPressCore, render: SceneRenderType) {
        self.root = root
        self.render = render
    }
    
    func action(with viewController: ListPostsDisplayable?) -> ListPostsActionable {
        ListPostsAction(
            presenter: presenter(with: viewController),
            postRepository: root.postRepository(),
            mediaRepository: root.mediaRepository()
        )
    }
    
    func presenter(with viewController: ListPostsDisplayable?) -> ListPostsPresentable {
        ListPostsPresenter(viewController: viewController)
    }
    
    func router(viewController: UIViewController?, listPostsDelegate: ListPostsDelegate?) -> ListPostsRouterable {
        ListPostsRouter(
            render: render,
            viewController: viewController,
            listPostsDelegate: listPostsDelegate
        )
    }
    
    func constants() -> ConstantsType {
        root.constants()
    }
    
    func theme() -> Theme {
        root.theme()
    }
}
