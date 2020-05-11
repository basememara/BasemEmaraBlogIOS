//
//  HomeInteractor.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import ZamzamCore

struct ShowSettingsInteractor: ShowSettingsInteractable {
    private let presenter: ShowSettingsPresentable
    private let preferences: Preferences
    
    init(presenter: ShowSettingsPresentable, preferences: Preferences) {
        self.presenter = presenter
        self.preferences = preferences
    }
}

extension ShowSettingsInteractor {
    
    func fetchMenu() {
        let menu = [
            ShowSettingsAPI.MenuItem(
                type: .theme,
                title: "Use iOS theme",
                icon: "theme"
            ),
            ShowSettingsAPI.MenuItem(
                type: .notifications,
                title: "Get notifications",
                icon: "notifications"
            ),
            ShowSettingsAPI.MenuItem(
                type: .ios,
                title: "iOS Settings",
                icon: "phone"
            )
        ]
        
        presenter.display(menu: menu)
    }
}

extension ShowSettingsInteractor {
    
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
