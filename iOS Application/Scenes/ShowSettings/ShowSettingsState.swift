//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

struct ShowSettingsState: StateType {
    private(set) var settingsMenu: [ShowSettingsAPI.MenuItem] = []
    private(set) var autoThemeEnabled: Bool = true
}

// MARK: - Reducer

extension ShowSettingsState {
    
    enum Action: ActionType {
        case loadMenu([ShowSettingsAPI.MenuItem])
        case setAutoThemeEnabled(Bool)
    }
    
    mutating func receive(_ action: Action) {
        switch action {
        case .loadMenu(let value):
            settingsMenu = value
        case .setAutoThemeEnabled(let value):
            autoThemeEnabled = value
        }
    }
}
