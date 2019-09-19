//
//  AppConfiguration.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import Shank
import SwiftyPress
import ZamzamCore

struct AppModule: Module {
    
    func register() {
        // Declare environment mode
        let environment: Environment = {
            #if DEBUG
            return .development
            #elseif STAGING
            return .staging
            #else
            return .production
            #endif
        }()
        
        make {
            ConstantsMemoryStore(
                environment: environment,
                itunesName: "basememara",
                itunesID: "1021806851",
                baseURL: {
                    let string: String
                    switch environment {
                    case .development:
                        string = "https://basememara.com"
                    case .staging:
                        string = "https://staging1.basememara.com"
                    case .production:
                        string = "https://basememara.com"
                    }
                    
                    guard let url = URL(string: string) else {
                        fatalError("Could not determine base URL of server.")
                    }
                    
                    return url
                }(),
                baseREST: "wp-json/swiftypress/v5",
                wpREST: "wp-json/wp/v2",
                email: "contact@basememara.com",
                privacyURL: "https://basememara.com/privacy/?mobileembed=1",
                disclaimerURL: nil,
                styleSheet: "https://basememara.com/wp-content/themes/metro-pro/style.css",
                googleAnalyticsID: "UA-60131988-2",
                featuredCategoryID: 64,
                defaultFetchModifiedLimit: 25,
                taxonomies: ["category", "post_tag", "series"],
                postMetaKeys: ["_series_part"],
                logFileName: "basememara"
            ) as ConstantsStore
        }
        make {
            PreferencesDefaultsStore(
                defaults: {
                    let constants: ConstantsType = self.resolve()
                    
                    return UserDefaults(
                        suiteName: {
                            switch constants.environment {
                            case .development, .staging:
                                return "group.io.zamzam.Basem-Emara-staging"
                            case .production:
                                return "group.io.zamzam.Basem-Emara"
                            }
                        }()
                    ) ?? .standard
                }()
            ) as PreferencesStore
        }
        make {
            SeedFileStore(
                forResource: "seed.json",
                inBundle: .main
            ) as SeedStore
        }
        make { AppTheme() as Theme }
    }
}
