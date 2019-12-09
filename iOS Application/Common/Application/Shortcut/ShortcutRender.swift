//
//  ShortcutRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-08.
//

import Foundation
import SwiftyPress
import ZamzamCore
import ZamzamUI
import UIKit

protocol ShortcutRenderable: AppRoutable {
    func showFavorites()
    func sendFeedback()
}

struct ShortcutRender: ShortcutRenderable {
    private let render: SceneRenderType
    private let constants: ConstantsType
    
    weak var viewController = UIWindow.current?.rootViewController
    
    init(
        render: SceneRenderType,
        constants: ConstantsType
    ) {
        self.render = render
        self.constants = constants
    }
}

extension ShortcutRender {
    
    func showFavorites() {
        show(tab: .favorites)
    }
    
    func sendFeedback() {
        show(tab: .more) { (controller: ShowMoreViewController) in
            controller.render?.sendFeedback(
                subject: .localizedFormat(
                    .emailFeedbackSubject,
                    self.constants.appDisplayName ?? ""
                )
            )
        }
    }
}
