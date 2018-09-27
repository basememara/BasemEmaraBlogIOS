//
//  ThemeApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

final class ThemeApplicationService: ApplicationService, HasDependencies {
    private let theme: Theme = DarkTheme()
}

extension ThemeApplicationService {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        theme.apply(for: application)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            LightTheme().apply(for: application)
        }
        
        return true
    }
}
