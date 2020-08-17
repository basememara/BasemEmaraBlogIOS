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
    private let state: Reduce<ShowSettingsReducer>
    
    init(state: @escaping Reduce<ShowSettingsReducer>) {
        self.state = state
    }
}

extension ShowSettingsPresenter {
    
    func display(menu: [ShowSettingsAPI.MenuItem]) {
        state(.loadMenu(menu))
    }
}

extension ShowSettingsPresenter {
    
    func displayTheme(for response: ShowSettingsAPI.SetThemeResponse) {
        state(.setAutoThemeEnabled(response.autoThemeEnabled))
    }
}
