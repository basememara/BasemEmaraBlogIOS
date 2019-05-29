//
//  MainSplitRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

protocol MainSplitRoutable: AppRoutable & DeepLinkRoutable {
    
}

struct MainSplitRouter: MainSplitRoutable {
    weak var viewController: UIViewController?
    let constants: ConstantsType
    
    init(viewController: UIViewController, constants: ConstantsType) {
        self.viewController = viewController
        self.constants = constants
    }
}
