//
//  CoreApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamUI

final class DependencyApplicationModule: ApplicationModule {
    private let container = Container() // Dependency injection
    
    init() {
        container.import {
            CoreModule.self
            AppModule.self
        }
    }
}
