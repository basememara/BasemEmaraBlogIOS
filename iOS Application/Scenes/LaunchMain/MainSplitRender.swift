//
//  MainSplitRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-08.
//

import Foundation
import SwiftyPress
import UIKit
import ZamzamUI

protocol MainSplitRenderable {
    func showPost(for id: Int)
}

struct MainSplitRender: MainSplitRenderable {
    private let render: SceneRenderType
    
    init(render: SceneRenderType) {
        self.render = render
    }
}

extension MainSplitRender {
    
    func showPost(for id: Int) {
        guard let topViewController = UIWindow.current?.topViewController else {
            return
        }
        
        // Load post in place or show in new controller
        (topViewController as? ShowPostLoadable)?.loadData(for: id)
            ?? topViewController.show(render.showPost(for: id), dismiss: true)
    }
}
