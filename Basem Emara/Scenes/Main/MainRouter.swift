//
//  MainRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

protocol MainRoutable: AppRoutable {
    func showFavorites()
    func sendFeedback()
}

struct MainRouter {
    weak var viewController: UIViewController?
    private let constants: ConstantsType
    
    init(viewController: UIViewController, constants: ConstantsType) {
        self.viewController = viewController
        self.constants = constants
    }
}

extension MainRouter: MainRoutable {
    
    func showFavorites() {
        show(tab: .favorites)
    }
    
    func sendFeedback() {
        show(tab: .more) { (controller: ShowMoreViewController) in
            controller.router.sendFeedback(
                subject: .localizedFormat(
                    .emailFeedbackSubject,
                    self.constants.appDisplayName ?? ""
                )
            )
        }
    }
}
