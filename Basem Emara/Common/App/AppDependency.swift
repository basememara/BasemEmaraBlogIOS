//
//  AppDependency.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

class AppDependency: Dependency {
    
    override func resolveStore() -> ConstantsStore {
        return ConstantsMemoryStore(
            itunesName: "basememara",
            itunesID: "1021806851",
            baseURL: URL(string: "http://basememara.com")!,
            baseREST: "wp-json/swiftypress/v2",
            wpREST: "wp-json/wp/v2",
            email: "contact@basememara.com",
            styleSheet: "http://basememara.com/wp-content/themes/metro-pro/style.css",
            googleAnalyticsID: "UA-60131988-2",
            featuredCategoryID: 64,
            logFileName: "basememara",
            logDNAKey: nil
        )
    }
    
    override func resolveStore() -> PreferencesStore {
        return PreferencesDefaultsStore(
            defaults: {
                UserDefaults(
                    suiteName: {
                        switch Environment.mode {
                        case .development, .staging: return "group.io.zamzam.Basem-Emara-staging"
                        case .production: return "group.io.zamzam.Basem-Emara"
                        }
                    }()
                ) ?? .standard
            }()
        )
    }
}
