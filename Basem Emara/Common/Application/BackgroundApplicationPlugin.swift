//
//  BackgroundApplicationPlugin.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftyPress
import UIKit
import UserNotifications
import ZamzamCore
import ZamzamNotification
import ZamzamUI

final class BackgroundApplicationPlugin: ApplicationPlugin, Loggable {
    private let userNotification: UNUserNotificationCenter = .current()
    
    @Inject private var dataWorker: DataWorkerType
}

extension BackgroundApplicationPlugin {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Enable background fetch for creating local notifications for new content
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        return true
    }
}

extension BackgroundApplicationPlugin {
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Create local notifications when new content retrieved via background fetch
        dataWorker.pull {
            // Validate if any updates that needs to be notified
            guard case .success = $0 else { return completionHandler(.failed) }
            
            guard case .success(let value) = $0,
                let post = value.posts.sorted(by: { $0.createdAt > $1.createdAt }).first else {
                    return completionHandler(.noData)
            }
            
            var attachments = [UNNotificationAttachment]()
            var mediaURL = ""
            
            // Create local notification on exit
            func deferred() {
                self.userNotification.add(
                    body: post.excerpt,
                    title: post.title,
                    attachments: attachments,
                    timeInterval: 60,
                    category: NotificationApplicationPlugin.Category.post.rawValue,
                    userInfo: [
                        "id": post.id,
                        "link": post.link,
                        "mediaURL": mediaURL
                    ],
                    completion: {
                        guard $0 == nil else { return self.Log(error: "Could not schedule the notification for the post: \($0.debugDescription).") }
                        self.Log(debug: "Scheduled notification for post during background fetch.")
                    }
                )
                
                completionHandler(.newData)
            }
            
            // Get remote media to attach to notification
            guard let mediaID = post.mediaID, let media = value.media
                .first(where: { $0.id == mediaID }) else {
                    return deferred()
            }
            
            let thread = Thread.current
            mediaURL ?= media.thumbnailLink
            
            // Attach media to notification if applicable
            UNNotificationAttachment.download(from: media.thumbnailLink) {
                defer { thread.async { deferred() } }
                
                guard case .success(let attachment) = $0 else {
                    return self.Log(error: "Could not download the post thumbnail (\(String(describing: link))): \($0.error.debugDescription).")
                }
                
                // Store attachment to schedule notification later
                attachments.append(attachment)
            }
        }
    }
}
