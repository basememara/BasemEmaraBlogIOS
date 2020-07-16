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
#if canImport(SwiftUI)
import SwiftUI
#endif

protocol WindowRenderable {
    func launchMain() -> UIViewController
    
    @available(iOS 13, *)
    func launchMain<T: View>() -> T?
}

struct WindowRender: WindowRenderable {
    private let render: AppRender
    
    init(render: AppRender) {
        self.render = render
    }
}

extension WindowRender {
    
    func launchMain() -> UIViewController {
        render.launchMain()
    }
    
    @available(iOS 13, *)
    func launchMain<T: View>() -> T? {
        render.launchMain()
    }
}
