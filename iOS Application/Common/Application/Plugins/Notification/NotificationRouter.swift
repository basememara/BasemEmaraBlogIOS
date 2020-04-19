//
//  NotificationRouter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-08.
//

import Foundation
import SwiftyPress
import ZamzamUI
import UIKit

protocol NotificationRouterable {
    func showBlog(for id: Int)
    func share(title: String, link: String)
}

struct NotificationRouter: NotificationRouterable {
    private let render: SceneRenderType
    weak var viewController = UIWindow.current?.rootViewController
    
    init(render: SceneRenderType) {
        self.render = render
    }
}

extension NotificationRouter {
    
    func showBlog(for id: Int) {
        viewController?.show(menu: MainAPI.Menu.blog) { (controller: ShowBlogViewController) in
            controller.render?.showPost(for: id)
        }
    }
}

extension NotificationRouter {
    
    func share(title: String, link: String) {
        guard let popoverView = viewController?.view else { return }
        
        viewController?.present(
            activities: [title.htmlDecoded, link],
            popoverFrom: popoverView
        )
    }
}
