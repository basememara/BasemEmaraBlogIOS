//
//  NotificationViewController.swift
//  Post Notification Extension
//
//  Created by Basem Emara on 2018-05-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    // MARK: - Controls
    
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var detailLabel: UILabel?
    @IBOutlet private var featuredImage: UIImageView?
    
    // MARK: - Lifecycle
    
    func didReceive(_ notification: UNNotification) {
        titleLabel?.text = notification.request.content.title
        detailLabel?.text = notification.request.content.body
        featuredImage?.setImage(
            from: notification.request.content.userInfo["mediaURL"] as? String
        )
    }

}
