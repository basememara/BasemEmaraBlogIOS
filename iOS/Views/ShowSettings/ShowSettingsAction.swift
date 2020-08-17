//
//  ShowSettingsAction.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIImage
import ZamzamCore

struct ShowSettingsAction: ShowSettingsActionable {
    private let presenter: ShowSettingsPresentable
    private let preferences: Preferences
    
    init(presenter: ShowSettingsPresentable, preferences: Preferences) {
        self.presenter = presenter
        self.preferences = preferences
    }
}

extension ShowSettingsAction {
    
    func fetchMenu() {
        let menu = [
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
        
        presenter.display(menu: menu)
    }
}

extension ShowSettingsAction {
    
    func fetchTheme() {
        let response = ShowSettingsAPI.SetThemeResponse(
            autoThemeEnabled: preferences.autoThemeEnabled
        )
        
        presenter.displayTheme(for: response)
    }
    
    func setTheme(with request: ShowSettingsAPI.SetThemeRequest) {
        preferences.set(autoThemeEnabled: request.autoThemeEnabled)
        
        let response = ShowSettingsAPI.SetThemeResponse(
            autoThemeEnabled: preferences.autoThemeEnabled
        )
        
        presenter.displayTheme(for: response)
    }
}
