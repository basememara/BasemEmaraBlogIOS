//
//  ShowMoreCore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ShowMoreCore: ShowMoreCoreType {
    private let core: SwiftyPressCore
    private let render: SceneRenderType
    
    init(core: SwiftyPressCore, render: SceneRenderType) {
        self.core = core
        self.render = render
    }
    
    func dependency(with viewController: UIViewController?) -> ShowMoreRenderable {
        ShowMoreRender(
            render: render,
            constants: core.dependency(),
            mailComposer: core.dependency(),
            theme: core.dependency(),
            viewController: viewController
        )
    }
    
    func dependency() -> ConstantsType {
        core.dependency()
    }
}
