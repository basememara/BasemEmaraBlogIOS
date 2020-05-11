//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

struct ShowSettingsPresenter<Store: StoreRepresentable>: ShowSettingsPresentable where Store.StateType == ShowSettingsState {
    private let store: Store
    
    init(store: Store) {
        self.store = store
    }
}

extension ShowSettingsPresenter {
    
    func display(menu: [ShowSettingsAPI.MenuItem]) {
        store.send(.loadMenu(menu))
    }
}

extension ShowSettingsPresenter {
    
    func displayTheme(for response: ShowSettingsAPI.SetThemeResponse) {
        store.send(.setAutoThemeEnabled(response.autoThemeEnabled))
    }
}
