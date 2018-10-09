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

struct ShowMoreRouter: ShowMoreRoutable {
    weak var viewController: UIViewController?
    
    private let mailComposer: MailComposerType
    private let constants: ConstantsType
    private let theme: Theme
    
    init(viewController: UIViewController?, constants: ConstantsType, theme: Theme) {
        self.viewController = viewController
        self.mailComposer = MailComposer(tintColor: theme.tint)
        self.constants = constants
        self.theme = theme
    }
}

extension ShowMoreRouter {
    
    func showAbout() {
        viewController?.present(
            safari: constants.baseURL
                .appendingPathComponent("about")
                .appendingQueryItem("mobileembed", value: 1)
                .absoluteString,
            theme: theme
        )
    }
    
    func showSubscribe() {
        viewController?.present(
            safari: constants.baseURL
                .appendingPathComponent("subscribe")
                .appendingQueryItem("mobileembed", value: 1)
                .absoluteString,
            theme: theme
        )
    }
    
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
        
        viewController?.present(controller, animated: true)
    }
    
    func showWorkWithMe() {
        viewController?.present(
            safari: constants.baseURL
                .appendingPathComponent("resume")
                .appendingQueryItem("mobileembed", value: 1)
                .absoluteString,
            theme: theme
        )
    }
    
    func showRateApp() {
        UIApplication.shared.open(URL(string: constants.itunesURL)!)
    }
    
    func showSettings() {
        show(storyboard: .showSettings)
    }
    
    func showDevelopedBy() {
        UIApplication.shared.open(constants.baseURL)
    }
}

extension ShowMoreRouter {
    
    func showSocial(for type: Social) {
        // Open social app or url
        guard let shortcut = type.shortcut(for: "basememara"), UIApplication.shared.canOpenURL(shortcut) else {
            viewController?.present(safari: type.link(for: "basememara"), theme: theme)
            return
        }
        
        UIApplication.shared.open(shortcut)
    }
}
