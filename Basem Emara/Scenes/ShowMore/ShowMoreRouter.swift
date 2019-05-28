//
//  ShowMoreRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

struct ShowMoreRouter: ShowMoreRoutable, HasScenes {
    weak var viewController: UIViewController?
    
    private let constants: ConstantsType
    private let mailComposer: MailComposerType
    private let theme: Theme
    
    init(
        viewController: UIViewController,
        constants: ConstantsType,
        mailComposer: MailComposerType,
        theme: Theme
    ) {
        self.viewController = viewController
        self.constants = constants
        self.mailComposer = mailComposer
        self.theme = theme
    }
}

extension ShowMoreRouter {
    
    func showSubscribe() {
        show(safari: "subscribe", constants: constants, theme: theme)
    }
    
    func showWorkWithMe() {
        show(safari: "resume", constants: constants, theme: theme)
    }
    
    func showSocial(for type: Social) {
        showSocial(for: type, theme: theme)
    }
    
    func showDevelopedBy() {
        UIApplication.shared.open(constants.baseURL)
    }
}

extension ShowMoreRouter {
    
    func showRateApp() {
        guard let url = URL(string: constants.itunesURL) else { return }
        UIApplication.shared.open(url)
    }
    
    func showSettings() {
        let controller = scenes.showSettings()
        viewController?.show(controller)
    }
}

extension ShowMoreRouter {
    
    func sendFeedback(subject: String) {
        let mailComposerController = mailComposer.makeViewController(
            email: constants.email,
            subject: subject,
            body: nil,
            attachment: nil
        )
        
        guard let controller = mailComposerController else {
            viewController?.present(
                alert: .localized(.couldNotSendEmail),
                message: .localized(.couldNotSendEmailMessage)
            )
            
            return
        }
        
        viewController?.present(controller)
    }
}
