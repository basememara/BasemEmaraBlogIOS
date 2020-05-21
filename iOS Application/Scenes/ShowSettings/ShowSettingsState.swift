//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification

class ShowSettingsState: StateRepresentable {
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var settingsMenu: [ShowSettingsAPI.MenuItem] = [] {
        willSet {
            guard newValue != settingsMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != settingsMenu else { return }
            notificationPost(for: \Self.settingsMenu)
        }
    }
    
    private(set) var autoThemeEnabled: Bool = true {
        willSet {
            guard newValue != autoThemeEnabled, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != autoThemeEnabled else { return }
            notificationPost(for: \Self.autoThemeEnabled)
        }
    }
}

extension ShowSettingsState {
    
    func subscribe(_ observer: @escaping (PartialKeyPath<ShowSettingsState>?) -> Void) {
        subscribe(observer, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

// MARK: - Action

enum ShowSettingsAction: Action {
    case loadMenu([ShowSettingsAPI.MenuItem])
    case setAutoThemeEnabled(Bool)
}

// MARK: - Reducer

extension ShowSettingsState {
    
    func callAsFunction(_ action: ShowSettingsAction) {
        switch action {
        case .loadMenu(let items):
            settingsMenu = items
        case .setAutoThemeEnabled(let item):
            autoThemeEnabled = item
        }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ShowSettingsState: ObservableObject {}
#endif
