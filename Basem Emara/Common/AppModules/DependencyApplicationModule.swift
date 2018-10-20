//
//  CoreApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

final class DependencyApplicationModule: ApplicationModule, DependencyConfigurator {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        register(dependencies: AppDependencyFactory())
        return true
    }
}

private extension DependencyApplicationModule {
    
    class AppDependencyFactory: DependencyFactory {
        
        override func resolveStore() -> ConstantsStore {
            return ConstantsMemoryStore(
                itunesName: "basememara",
                itunesID: "1021806851",
                baseURL: URL(string: "http://basememara.com")!,
                baseREST: "wp-json/swiftypress/v3",
                wpREST: "wp-json/wp/v2",
                email: "contact@basememara.com",
                privacyURL: "https://basememara.com/privacy/?mobileembed=1",
                disclaimerURL: "https://basememara.com/disclaimer/?mobileembed=1",
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
        
        override func resolveStore() -> SeedStore {
            return SeedFileStore(
                forResource: "seed.json",
                inBundle: .main
            )
        }
        
        override func resolve() -> Theme {
            let preferences: PreferencesType = resolve()
            
            guard let value: String = preferences.get(.currentTheme),
                let currentTheme = ThemePreset(rawValue: value) else {
                    return ThemePreset.default.type
            }
            
            return currentTheme.type
        }
    }
}
