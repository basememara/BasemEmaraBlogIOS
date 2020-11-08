//
//  ShowSettingsModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import ZamzamUI

class ShowSettingsModel: ObservableObject, Model {
    @Published var settingsMenu: [ShowSettingsAPI.MenuItem]?
    @Published var autoThemeEnabled = true
}
