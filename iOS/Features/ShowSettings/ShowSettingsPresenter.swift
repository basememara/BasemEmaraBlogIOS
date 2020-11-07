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
    var model: ShowSettingsState
}

extension ShowSettingsPresenter {
    
    func display(menu: [ShowSettingsAPI.MenuItem]) {
        model.settingsMenu = menu
    }
}

extension ShowSettingsPresenter {
    
    func displayTheme(for response: ShowSettingsAPI.SetThemeResponse) {
        model.autoThemeEnabled = response.autoThemeEnabled
    }
}
