//
//  BackgroundPlugin.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import BackgroundTasks
import SwiftyPress
import UIKit
import UserNotifications
import ZamzamCore
import ZamzamNotification

final class BackgroundPlugin {
    
    // MARK: Dependencies
    
    @Inject private var module: SwiftyPressModule
    
    private lazy var dataWorker: DataWorkerType = module.component()
    private lazy var preferences: PreferencesType = module.component()
    private lazy var log: LogWorkerType = module.component()
    
    // MARK: State
    
    private let userNotification: UNUserNotificationCenter = .current()
    private let taskIdentifier = "io.zamzam.Basem-Emara.backgroundRefresh"
}

extension BackgroundPlugin: ApplicationPlugin {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Enable background fetch for creating local notifications for new content
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { [weak self] in
                guard let task = $0 as? BGAppRefreshTask else { return }
                self?.log.info("Background fetching starting from `BGTaskScheduler`...")
                
                self?.handleBackgroundTask { [weak self] result in
                    // Test
                    UNUserNotificationCenter.current().add(
                        body: "Triggered from BGTaskScheduler",
                        timeInterval: 60,
                        completion: {
                            guard $0 == nil else { self?.log.error("Could not schedule the test notification for background task."); return }
                            self?.log.debug("Scheduled notification for test during background fetch.")
                        }
                    )
                    
                    switch result {
                    case .success:
                        self?.log.info("Background fetching completed")
                        task.setTaskCompleted(success: true)
                    case .failure(let error):
                        guard case .nonExistent = error else {
                            self?.log.error("Background fetching failed: \(error)")
                            task.setTaskCompleted(success: false)
                            break
                        }
                        
                        self?.log.info("Background fetching completed with no data")
                        task.setTaskCompleted(success: true)
                    }
                }
            }
        } else { // iOS 12 and below
            application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        }
        
        return true
    }
    
    // iOS 12 and below
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if #available(iOS 13.0, *) {} else {
            log.info("Background fetching starting...")
            
            handleBackgroundTask { [weak self] result in
                // Test
                UNUserNotificationCenter.current().add(
                    body: "Triggered from background performFetchWithCompletionHandler",
                    timeInterval: 60,
                    completion: {
                        guard $0 == nil else { self?.log.error("Could not schedule the test notification for background task."); return }
                        self?.log.debug("Scheduled notification for test during background fetch.")
                    }
                )
                
                switch result {
                case .success:
                    self?.log.info("Background fetching completed")
                    completionHandler(.newData)
                case .failure(let error):
                    guard case .nonExistent = error else {
                        self?.log.error("Background fetching failed: \(error)")
                        completionHandler(.failed)
                        break
                    }
                    
                    self?.log.info("Background fetching completed with no data.")
                    completionHandler(.noData)
                }
            }
        }
    }
}

extension BackgroundPlugin: ScenePlugin {
    
    func sceneDidEnterBackground() {
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.cancelAllTaskRequests()
            
            let request = BGAppRefreshTaskRequest(identifier: taskIdentifier).with {
                $0.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60)
            }
            
            do {
                try BGTaskScheduler.shared.submit(request)
                log.info("Scheduled background refresh for '\(taskIdentifier)'")
            } catch {
                log.error("Could not schedule background refresh for '\(taskIdentifier)': \(error)")
            }
        }
    }
}

private extension BackgroundPlugin {
    
    func handleBackgroundTask(completion: @escaping (Result<Void, ZamzamError>) -> Void) {
        // Create local notifications when new content retrieved via background fetch
        dataWorker.pull {
            // Validate if any updates that needs to be notified
            guard case .success = $0 else {
                completion(.failure(.general))
                return
            }
            
            guard case .success(let value) = $0,
                let post = value.posts.sorted(by: { $0.createdAt > $1.createdAt }).first else {
                    completion(.failure(.nonExistent))
                    return
            }
            
            // Do not bother user again about post notified before
            guard !self.preferences.notificationPostIDs.contains(post.id) else {
                completion(.failure(.nonExistent))
                return
            }
            
            self.preferences.notificationPostIDs.append(post.id)
            
            var attachments: [UNNotificationAttachment] = []
            var mediaURL = ""
            
            // Create local notification on exit
            func deferred() {
                self.userNotification.add(
                    body: post.excerpt,
                    title: post.title,
                    attachments: attachments,
                    timeInterval: 60,
                    category: NotificationPlugin.Category.post.rawValue,
                    userInfo: [
                        "id": post.id,
                        "link": post.link,
                        "mediaURL": mediaURL
                    ],
                    completion: {
                        guard $0 == nil else { return self.log.error("Could not schedule the notification for the post: \($0.debugDescription).") }
                        self.log.debug("Scheduled notification for post during background fetch.")
                    }
                )
                
                completion(.success(()))
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
                    self.log.error("Could not download the post thumbnail (\(String(describing: link))): \($0.error.debugDescription).")
                    return
                }
                
                // Store attachment to schedule notification later
                attachments.append(attachment)
            }
        }
    }
}
