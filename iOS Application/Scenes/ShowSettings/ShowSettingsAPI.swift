//
//  ShowSettingsAPI.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol ShowSettingsInteractorType: InteractorType {
    func fetchMenu()
    func fetchTheme()
    func setTheme(with request: ShowSettingsAPI.SetThemeRequest)
}

protocol ShowSettingsPresenterType: PresenterType {
    func display(menu: [ShowSettingsAPI.MenuItem])
    func displayTheme(for response: ShowSettingsAPI.SetThemeResponse)
}

protocol ShowSettingsRenderType: RenderType {
    func openSettings()
}

// MARK: - Namespace

enum ShowSettingsAPI {
    
    enum Menu: String {
        case theme
        case notifications
        case ios
    }
    
    struct MenuItem {
        let type: Menu
        let title: String
        let icon: String
    }
    
    struct SetThemeRequest {
        let autoThemeEnabled: Bool
    }
    
    struct SetThemeResponse {
        let autoThemeEnabled: Bool
    }
}
