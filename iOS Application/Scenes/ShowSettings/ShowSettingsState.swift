//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

struct ShowSettingsState: State {
    private(set) var settingsMenu: [ShowSettingsAPI.MenuItem] = []
    private(set) var autoThemeEnabled: Bool = true
}

// MARK: - Reducer

extension ShowSettingsState {
    
    enum ShowSettingsAction: Action {
        case loadMenu([ShowSettingsAPI.MenuItem])
        case setAutoThemeEnabled(Bool)
    }
    
    mutating func receive(_ action: ShowSettingsAction) {
        switch action {
        case .loadMenu(let value):
            settingsMenu = value
        case .setAutoThemeEnabled(let value):
            autoThemeEnabled = value
        }
    }
}
