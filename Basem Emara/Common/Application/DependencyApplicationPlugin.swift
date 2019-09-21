//
//  CoreApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Shank
import ZamzamUI

final class DependencyApplicationPlugin: ApplicationPlugin {
    
    init(_ modules: [Module]) {
        modules.register()
    }
}
