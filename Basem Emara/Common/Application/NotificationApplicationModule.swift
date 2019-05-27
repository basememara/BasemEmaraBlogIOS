//
//  NotificationApplicationModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit
import UserNotifications

final class NotificationApplicationModule: NSObject, ApplicationModule, Loggable {
    private let userNotification: UNUserNotificationCenter = .current()
}

extension NotificationApplicationModule {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
            completion: { granted in
                granted
                    ? self.Log(debug: "Authorization for notification succeeded.")
                    : self.Log(warn: "Authorization for notification not given.")
            }
        )
        
        return true
    }
}

extension NotificationApplicationModule {
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}

extension NotificationApplicationModule: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        
        guard let appViewController = (UIWindow.current?.rootViewController as? MainViewController),
            let id = response.notification.request.content.userInfo["id"] as? Int,
            let link = response.notification.request.content.userInfo["link"] as? String else {
                return
        }
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            appViewController.router.show(tab: .dashboard) { (controller: ShowBlogViewController) in
                controller.router.showPost(for: id)
            }
        case Action.share.rawValue:
            appViewController.present(
                activities: [response.notification.request.content.title.htmlDecoded, link],
                popoverFrom: appViewController.view
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
