//
//  NotificationApplicationModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI
import UserNotifications

final class NotificationApplicationModule: NSObject, ApplicationModule, Loggable {
    private let userNotification: UNUserNotificationCenter = .current()
    
    @Inject var constants: ConstantsType
    
    private lazy var router: DeepLinkRoutable = DeepLinkRouter(
        viewController: UIWindow.current?.rootViewController,
        constants: constants
    )
}

extension NotificationApplicationModule {
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}

extension NotificationApplicationModule: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        
        guard let id = response.notification.request.content.userInfo["id"] as? Int,
            let link = response.notification.request.content.userInfo["link"] as? String else {
                return
        }
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            router.show(tab: .blog) { (controller: ShowBlogViewController) in
                controller.router.showPost(for: id)
            }
        case Action.share.rawValue:
            guard let popoverView = router.viewController?.view else { return }
            router.viewController?.present(
                activities: [response.notification.request.content.title.htmlDecoded, link],
                popoverFrom: popoverView
            )
        default:
            break
        }
    }
}

extension NotificationApplicationModule {
    
    enum Category: String {
        case post = "postCategory"
    }
    
    enum Action: String {
        case share = "shareAction"
    }
}

extension NotificationApplicationModule {
    
    func register(completion: @escaping (Bool) -> Void) {
        userNotification.register(
            delegate: self,
            categories: [
                Category.post.rawValue: [
                    UNNotificationAction(
                        identifier: Action.share.rawValue,
                        title: .localized(.shareTitle),
                        options: [.foreground]
                    )
                ]
            ],
            completion: completion
        )
    }
}
