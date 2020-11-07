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

struct NotificationRender {
    private let render: AppRender
    
    init(render: AppRender) {
        self.render = render
    }
}

private extension NotificationRender {
    var viewController: UIViewController? { UIApplication.shared.currentWindow?.rootViewController }
}

extension NotificationRender {
    
    func showBlog(for id: Int) {
        viewController?.show(menu: MainAPI.Menu.blog, configure: nil) { (controller: ShowBlogViewController) in
            controller.render?.showPost(for: id)
        }
    }
}

extension NotificationRender {
    
    func share(title: String, link: String) {
        guard let popoverView = viewController?.view else { return }
        
        viewController?.present(
            activities: [title.htmlDecoded, link],
            popoverFrom: popoverView
        )
    }
}
