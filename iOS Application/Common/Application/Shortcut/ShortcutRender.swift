//
//  ShortcutRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-08.
//

import SwiftyPress
import ZamzamCore
import UIKit.UIApplication

struct ShortcutRender {
    private let render: SceneRender
    private let constants: Constants
    
    weak var viewController = UIApplication.shared.currentWindow?.rootViewController
    
    init(render: SceneRender, constants: Constants) {
        self.render = render
        self.constants = constants
    }
}

extension ShortcutRender {
    
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
