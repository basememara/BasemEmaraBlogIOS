//
//  UIViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-01-13.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     Display an alert with an action to the application settings.
     
     - parameter settings: Title of the alert.
     - parameter message: Body of the alert.
     - parameter handler: Call back handler when main action tapped.
     */
    func present(settings: String, message: String? = nil, handler: (() -> Void)? = nil) {
        present(
            alert: settings,
            message: message,
            additionalActions: [
                UIAlertAction(title: .localized(.settingsTitle)) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            ],
            handler: handler
        )
    }
}
