//
//  WindowRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-08.
//

import Foundation
import SwiftyPress
import ZamzamUI
import UIKit
#if canImport(SwiftUI)
import SwiftUI
#endif

protocol WindowRenderable {
    func launchMain() -> UIViewController
    
    @available(iOS 13.0, *)
    func launchMain<T: View>() -> T?
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
    
    @available(iOS 13.0, *)
    func launchMain<T: View>() -> T? {
        render.launchMain()
    }
}
