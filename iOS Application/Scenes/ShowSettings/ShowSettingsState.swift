//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

class ShowSettingsState: StateRepresentable {
    
    private(set) var settingsMenu: [ShowSettingsAPI.MenuItem] = [] {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowSettingsState.settingsMenu) }
    }
    
    private(set) var autoThemeEnabled: Bool = true {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowSettingsState.autoThemeEnabled) }
    }
}

// MARK: - Action

enum ShowSettingsAction: Action {
    case loadMenu([ShowSettingsAPI.MenuItem])
    case setAutoThemeEnabled(Bool)
}

// MARK: - Reducer

extension ShowSettingsState {
    
    func reduce(_ action: ShowSettingsAction) {
        switch action {
        case .loadMenu(let items):
            settingsMenu = items
        case .setAutoThemeEnabled(let item):
            autoThemeEnabled = item
        }
    }
}

// MARK: - Conformances

extension ShowSettingsState: Equatable {
    
    static func == (lhs: ShowSettingsState, rhs: ShowSettingsState) -> Bool {
        lhs.settingsMenu == rhs.settingsMenu
            && lhs.autoThemeEnabled == rhs.autoThemeEnabled
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ShowSettingsState: ObservableObject {}
#endif
