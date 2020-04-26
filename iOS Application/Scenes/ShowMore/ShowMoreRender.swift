//
//  ShowMoreRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit.UIViewController
import ZamzamUI

struct ShowMoreRender: ShowMoreRenderType {
    private let render: SceneRenderType
    private let constants: ConstantsType
    private let mailComposer: MailComposerType
    private let theme: Theme
    private weak var presentationContext: UIViewController?
    
    init(
        render: SceneRenderType,
        constants: ConstantsType,
        mailComposer: MailComposerType,
        theme: Theme,
        presentationContext: UIViewController?
    ) {
        self.render = render
        self.constants = constants
        self.mailComposer = mailComposer
        self.theme = theme
        self.presentationContext = presentationContext
    }
}

extension ShowMoreRender {
    
    func select(menu: ShowMoreAPI.MenuItem, from view: UIView) {
        switch menu.type {
        case .subscribe:
            showSubscribe()
        case .feedback:
            sendFeedback(
                subject: .localizedFormat(
                    .emailFeedbackSubject,
                    constants.appDisplayName ?? ""
                )
            )
        case .work:
            showWorkWithMe()
        case .rate:
            showRateApp(from: .shared)
        case .share:
            share(
                appURL: constants.itunesURL,
                message: .localizedFormat(.shareAppMessage, constants.appDisplayName ?? ""),
                popoverFrom: view
            )
        case .settings:
            showSettings()
        case .social:
            break
        case .developedBy:
            showDevelopedBy()
        }
    }
    
    func select(social: Social) {
        presentationContext?.show(social: social, theme: theme)
    }
}

extension ShowMoreRender {
    
    func sendFeedback(subject: String) {
        let mailComposerController = mailComposer.makeViewController(
            email: constants.email,
            subject: subject,
            body: nil,
            isHTML: true,
            attachment: nil
        )
        
        guard let controller = mailComposerController else {
            presentationContext?.present(
                alert: .localized(.couldNotSendEmail),
                message: .localized(.couldNotSendEmailMessage)
            )
            
            return
        }
        
        presentationContext?.present(controller)
    }
}

private extension ShowMoreRender {
    
    func showSubscribe() {
        presentationContext?.modal(pageSlug: "subscribe", constants: constants, theme: theme)
    }
    
    func showWorkWithMe() {
        presentationContext?.modal(pageSlug: "resume", constants: constants, theme: theme)
    }
    
    func showDevelopedBy() {
        presentationContext?.modal(safari: constants.baseURL.absoluteString, theme: theme)
    }
    
    func showRateApp(from application: UIApplication) {
        guard let url = URL(string: constants.itunesURL) else { return }
        application.open(url)
    }
    
    func share(appURL: String, message: String, popoverFrom view: UIView) {
        let share = [message, appURL]
        presentationContext?.present(activities: share, popoverFrom: view)
    }
    
    func showSettings() {
        let controller = render.showSettings()
        presentationContext?.show(controller)
    }
}
