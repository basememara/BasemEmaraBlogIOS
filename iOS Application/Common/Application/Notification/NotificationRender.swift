//
//  NotificationRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-08.
//

import Foundation
import SwiftyPress
import ZamzamUI
import UIKit

protocol NotificationRenderable: AppRoutable {
    func showBlog(for id: Int)
}

struct NotificationRender: NotificationRenderable {
    private let render: SceneRenderType
    weak var viewController = UIWindow.current?.rootViewController
    
    init(render: SceneRenderType) {
        self.render = render
    }
}

extension NotificationRender {
    
    func showBlog(for id: Int) {
        show(tab: .blog) { (controller: ShowBlogViewController) in
            controller.render?.showPost(for: id)
        }
    }
}
