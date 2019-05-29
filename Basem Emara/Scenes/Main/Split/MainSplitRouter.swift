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

protocol MainSplitRoutable: AppRoutable {
    func showPost(for id: Int)
    func showFavorites()
    func sendFeedback()
}

struct MainSplitRouter: MainSplitRoutable, HasScenes {
    weak var viewController: UIViewController?
    private let constants: ConstantsType
    
    init(viewController: UIViewController, constants: ConstantsType) {
        self.viewController = viewController
        self.constants = constants
    }
}

extension MainSplitRouter {
    
    func showPost(for id: Int) {
        guard let topViewController = UIWindow.current?.topViewController else {
            return
        }
        
        // Load post in place or show in new controller
        (topViewController as? ShowPostLoadable)?.loadData(for: id)
            ?? topViewController.show(scenes.showPost(for: id), dismiss: true)
    }
}

extension MainSplitRouter {
    
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
