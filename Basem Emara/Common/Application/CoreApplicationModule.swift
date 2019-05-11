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

final class CoreApplicationModule: ApplicationModule, CoreInjection {
    
    init(with dependencies: CoreDependable) {
        inject(dependencies: dependencies)
    }
}
