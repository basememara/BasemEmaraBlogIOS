//
//  CoreApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Shank
import SwiftyPress
import ZamzamUI

final class DependencyApplicationPlugin: ApplicationPlugin {
    
    private let modules: [Module] = [
        CoreModule(),
        AppModule()
    ]
    
    init() {
        modules.register()
    }
}
