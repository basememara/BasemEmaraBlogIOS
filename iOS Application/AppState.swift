//
//  AppState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-14.
//

import UIKit

class AppState {
    private let notificationCenter: NotificationCenter
    
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    // MARK: - Sub-states
    
    var main: MainModelType? {
        didSet {
            guard let main = main else { return }
            
            notificationCenter.post(
                name: .AppStateDidUpdate,
                userInfo: [
                    "state": self,
                    "substate": main
                ]
            )
        }
    }
}

extension NSNotification.Name {
    static let AppStateDidUpdate = Notification.Name("AppStateDidUpdate")
}
