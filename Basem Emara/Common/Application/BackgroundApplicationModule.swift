//
//  BackgroundApplicationModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit
import UserNotifications

final class BackgroundApplicationModule: ApplicationModule, HasDependencies, Loggable {
    private lazy var dataWorker: DataWorkerType = dependencies.resolveWorker()
    private let userNotification: UNUserNotificationCenter = .current()
}

extension BackgroundApplicationModule {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Enable background fetch for creating local notifications for new content
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        return true
    }
}

extension BackgroundApplicationModule {
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Create local notifications when new content retrieved via background fetch
        dataWorker.sync {
            // Validate if any updates that needs to be notified
            guard $0.isSuccess else { return completionHandler(.failed) }
            
            guard let post = $0.value?.posts.sorted(by: { $0.createdAt > $1.createdAt }).first else {
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
                    category: NotificationApplicationModule.Category.post.rawValue,
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
            guard let mediaID = post.mediaID, let media = $0.value?.media
                .first(where: { $0.id == mediaID }) else {
                    return deferred()
            }
            
            let thread = Thread.current
            mediaURL ?= media.thumbnailLink
            
            // Attach media to notification if applicable
            UNNotificationAttachment.download(from: media.thumbnailLink) {
                defer { thread.async { deferred() } }
                
                guard $0.isSuccess, let attachment = $0.value else {
                    return self.Log(error: "Could not download the post thumbnail (\(link)): \($0.error.debugDescription).")
                }
                
                // Store attachment to schedule notification later
                attachments.append(attachment)
            }
        }
    }
}
