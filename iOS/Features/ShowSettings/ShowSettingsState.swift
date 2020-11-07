//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import ZamzamCore

class ShowSettingsState: ObservableObject, Apply {
    @Published var settingsMenu: [ShowSettingsAPI.MenuItem]?
    @Published var autoThemeEnabled = true
}
