//
//  ShowSettingsModel+Preview.swift
//  iOS
//
//  Created by Basem Emara on 2020-11-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIImage

extension ShowSettingsModel {
    
    static let preview = ShowSettingsModel().apply {
        $0.settingsMenu = [
            ShowSettingsAPI.MenuItem(
                type: .theme,
                title: .localized(.settingsMenuThemeTitle),
                icon: UIImage.ImageName.theme.rawValue
            ),
            ShowSettingsAPI.MenuItem(
                type: .notifications,
                title: .localized(.settingsMenuNotificationsTitle),
                icon: UIImage.ImageName.notifications.rawValue
            ),
            ShowSettingsAPI.MenuItem(
                type: .ios,
                title: .localized(.settingsMenuPhoneSettingsTitle),
                icon: UIImage.ImageName.phone.rawValue
            )
        ]
        
        $0.autoThemeEnabled = true
    }
}
