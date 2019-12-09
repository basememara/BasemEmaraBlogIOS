//
//  DeepLinkCore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-28.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftyPress
import UIKit
import ZamzamCore

struct DeepLinkCore: DeepLinkCoreType {
    private let core: SwiftyPressCore
    private let render: SceneRenderType
    
    init(core: SwiftyPressCore, render: SceneRenderType) {
        self.core = core
        self.render = render
    }
    
    func dependency() -> DeepLinkRenderable {
        DeepLinkRender(
            render: render,
            postProvider: core.dependency(),
            taxonomyProvider: core.dependency(),
            theme: core.dependency()
        )
    }
    
    func dependency() -> LogProviderType {
        core.dependency()
    }
}
