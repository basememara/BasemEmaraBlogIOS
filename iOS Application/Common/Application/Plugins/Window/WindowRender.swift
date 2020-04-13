//
//  WindowRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-08.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftyPress
import ZamzamUI
import UIKit

protocol WindowRenderable {
    func launchMain() -> UIViewController
}

struct WindowRender: WindowRenderable {
    private let render: SceneRenderType
    
    init(render: SceneRenderType) {
        self.render = render
    }
}

extension WindowRender {
    
    func launchMain() -> UIViewController {
        render.launchMain()
    }
}
