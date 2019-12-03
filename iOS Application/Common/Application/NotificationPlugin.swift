//
//  NotificationApplicationModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import UserNotifications
import ZamzamCore

final class NotificationPlugin: NSObject {
    private let deepLinkModule: DeepLinkModuleType
    private let router: DeepLinkRoutable
    private let userNotification: UNUserNotificationCenter
    
    init(
        deepLinkModule: DeepLinkModuleType,
        userNotification: UNUserNotificationCenter
    ) {
        self.deepLinkModule = deepLinkModule
        self.router = deepLinkModule.component()
        self.userNotification = userNotification
    }
}

// MARK: - Lifecycle

extension NotificationPlugin: ApplicationPlugin, ScenePlugin {
    
    func sceneDidBecomeActive() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

// MARK: - Delegates

extension NotificationPlugin: UNUserNotificationCenterDelegate {
    
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

// MARK: - Subtypes

extension NotificationPlugin {
    
    enum Category: String {
        case post = "postCategory"
    }
    
    enum Action: String {
        case share = "shareAction"
    }
}

// MARK: - Helpers

extension NotificationPlugin {
    
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
