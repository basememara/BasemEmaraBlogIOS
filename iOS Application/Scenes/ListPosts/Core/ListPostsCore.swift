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
    
    func dependency(with viewController: ListPostsDisplayable?) -> ListPostsActionable {
        ListPostsAction(
            presenter: dependency(with: viewController),
            postProvider: root.dependency(),
            mediaProvider: root.dependency()
        )
    }
    
    func dependency(with viewController: ListPostsDisplayable?) -> ListPostsPresentable {
        ListPostsPresenter(viewController: viewController)
    }
    
    func dependency(viewController: UIViewController?, listPostsDelegate: ListPostsDelegate?) -> ListPostsRouterable {
        ListPostsRouter(
            render: render,
            viewController: viewController,
            listPostsDelegate: listPostsDelegate
        )
    }
    
    func dependency() -> ConstantsType {
        root.dependency()
    }
    
    func dependency() -> Theme {
        root.dependency()
    }
}
