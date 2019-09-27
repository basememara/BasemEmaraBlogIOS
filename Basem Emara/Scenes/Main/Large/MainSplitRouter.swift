//
//  MainSplitRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI

protocol MainSplitRoutable: AppRoutable & DeepLinkRoutable {
    
}

struct MainSplitRouter: MainSplitRoutable {
    weak var viewController: UIViewController?
    
    let scenes: SceneModuleType
    let constants: ConstantsType
    
    init(
        viewController: UIViewController,
        scenes: SceneModuleType,
        constants: ConstantsType
    ) {
        self.viewController = viewController
        self.scenes = scenes
        self.constants = constants
    }
}
