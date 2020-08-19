//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamUI

struct ShowSettingsPresenter: ShowSettingsPresentable {
    private let store: StoreReducer<ShowSettingsReducer>
    
    init(_ store: @escaping StoreReducer<ShowSettingsReducer>) {
        self.store = store
    }
}

extension ShowSettingsPresenter {
    
    func display(menu: [ShowSettingsAPI.MenuItem]) {
        store(.loadMenu(menu))
    }
}

extension ShowSettingsPresenter {
    
    func displayTheme(for response: ShowSettingsAPI.SetThemeResponse) {
        store(.setAutoThemeEnabled(response.autoThemeEnabled))
    }
}
