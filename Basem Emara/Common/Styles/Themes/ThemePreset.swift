//
//  ThemePreset.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

enum ThemePreset: String {
    case dark
    case light
}

extension ThemePreset {
    static let `default`: ThemePreset =  .dark
    
    var type: Theme {
        switch self {
        case .dark:
            return DarkTheme()
        case .light:
            return LightTheme()
        }
    }
}
