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
    private let core: SwiftyPressCore
    private let render: SceneRenderType
    
    init(core: SwiftyPressCore, render: SceneRenderType) {
        self.core = core
        self.render = render
    }
    
    func dependency(with inputs: HomeAPI.RoutableInputs) -> HomeRenderable {
        HomeRender(
            render: render,
            viewController: inputs.viewController,
            listPostsDelegate: inputs.listPostsDelegate,
            mailComposer: core.dependency(),
            constants: core.dependency(),
            theme: core.dependency()
        )
    }
    
    func dependency() -> ConstantsType {
        core.dependency()
    }
    
    func dependency() -> Theme {
        core.dependency()
    }
}
