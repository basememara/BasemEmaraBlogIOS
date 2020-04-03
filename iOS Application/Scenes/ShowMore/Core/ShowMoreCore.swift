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
    private let root: SwiftyPressCore
    private let render: SceneRenderType
    
    init(root: SwiftyPressCore, render: SceneRenderType) {
        self.root = root
        self.render = render
    }
    
    func router(with viewController: UIViewController?) -> ShowMoreRouterable {
        ShowMoreRouter(
            render: render,
            constants: root.constants(),
            mailComposer: root.mailComposer(),
            theme: root.theme(),
            viewController: viewController
        )
    }
    
    func constants() -> ConstantsType {
        root.constants()
    }
}
