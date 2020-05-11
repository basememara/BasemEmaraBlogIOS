//
//  ShortcutRouter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-08.
//

import Foundation
import SwiftyPress
import ZamzamCore
import ZamzamUI
import UIKit

protocol ShortcutRouterable {
    func showFavorites()
    func sendFeedback()
}

struct ShortcutRouter: ShortcutRouterable {
    private let render: SceneRenderable
    private let constants: Constants
    
    weak var viewController = UIApplication.shared.currentWindow?.rootViewController
    
    init(
        render: SceneRenderable,
        constants: Constants
    ) {
        self.render = render
        self.constants = constants
    }
}

extension ShortcutRouter {
    
    func showFavorites() {
        viewController?.show(menu: MainAPI.Menu.favorites)
    }
    
    func sendFeedback() {
        viewController?.show(menu: MainAPI.Menu.more) { (controller: ShowMoreViewController) in
            controller.render?.sendFeedback(
                subject: .localizedFormat(
                    .emailFeedbackSubject,
                    self.constants.appDisplayName ?? ""
                )
            )
        }
    }
}
