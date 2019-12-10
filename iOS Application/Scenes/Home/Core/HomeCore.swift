//
//  HomeCore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

struct HomeCore: HomeCoreType {
    private let root: SwiftyPressCore
    private let render: SceneRenderType
    
    init(root: SwiftyPressCore, render: SceneRenderType) {
        self.root = root
        self.render = render
    }
    
    func dependency(with inputs: HomeAPI.RoutableInputs) -> HomeRenderable {
        HomeRender(
            render: render,
            viewController: inputs.viewController,
            listPostsDelegate: inputs.listPostsDelegate,
            mailComposer: root.dependency(),
            constants: root.dependency(),
            theme: root.dependency()
        )
    }
    
    func dependency() -> ConstantsType {
        root.dependency()
    }
    
    func dependency() -> Theme {
        root.dependency()
    }
}
