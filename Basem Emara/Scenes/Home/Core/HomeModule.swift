//
//  HomeModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress
import ZamzamUI

struct HomeModule: HomeModuleType {
    
    func resolve(with inputs: HomeAPI.RoutableInputs) -> HomeRoutable {
        HomeRouter(
            viewController: inputs.viewController,
            listPostsDelegate: inputs.listPostsDelegate,
            scenes: resolve(),
            mailComposer: resolve(),
            constants: resolve(),
            theme: resolve()
        )
    }
}

extension HomeModule: Module {
    
    func register() {
        make { self as HomeModuleType }
    }
}
