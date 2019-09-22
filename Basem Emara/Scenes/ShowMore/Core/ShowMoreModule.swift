//
//  ShowMoreModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress

struct ShowMoreModule: ShowMoreModuleType {
    
    func resolve(with viewController: UIViewController?) -> ShowMoreRoutable {
        ShowMoreRouter(
            viewController: viewController,
            scenes: resolve(),
            constants: resolve(),
            mailComposer: resolve(),
            theme: resolve()
        )
    }
}

extension ShowMoreModule: Module {
    
    func register() {
        make { self as ShowMoreModuleType }
    }
}
