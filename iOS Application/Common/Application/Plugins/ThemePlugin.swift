//
//  ThemeApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ThemePlugin: ApplicationPlugin {
    private let theme: Theme
    
    init(theme: Theme) {
        self.theme = theme
    }
}

extension ThemePlugin {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        theme.apply(for: application)
        return true
    }
}
