//
//  ShowBlogRender.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI

struct ShowBlogRender: ShowBlogRenderable {
    private let render: SceneRenderable
    private let mailComposer: MailComposerType?
    private let theme: Theme?
    
    private weak var presentationContext: UIViewController?
    
    init(
        render: SceneRenderable,
        mailComposer: MailComposerType?,
        theme: Theme?,
        presentationContext: UIViewController?
    ) {
        self.render = render
        self.mailComposer = mailComposer
        self.theme = theme
        self.presentationContext = presentationContext
    }
}

extension ShowBlogRender {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = render.listPosts(params: params)
        presentationContext?.show(controller)
    }
    
    func showPost(for model: PostsDataViewModel) {
        let controller = render.showPost(for: model.id)
        presentationContext?.show(controller)
    }
    
    func showPost(for id: Int) {
        let controller = render.showPost(for: id)
        presentationContext?.show(controller)
    }
}

extension ShowBlogRender {
    
    func listTerms() {
        let controller = render.listTerms()
        presentationContext?.show(controller)
    }
}

extension ShowBlogRender {
    
    func showDisclaimer(url: String?) {
        guard let url = url, let theme = theme else {
            showDisclaimerError()
            return
        }
        
        presentationContext?.modal(safari: url, theme: theme)
    }
    
    func showDisclaimerError() {
        presentationContext?.present(
            alert: .localized(.disclaimerNotAvailableErrorTitle),
            message: .localized(.disclaimerNotAvailableErrorMessage)
        )
    }
}

extension ShowBlogRender {
    
    func show(url: String?) {
        guard let url = url, let theme = theme else { return }
        presentationContext?.modal(safari: url, theme: theme)
    }
}

extension ShowBlogRender {
    
    func sendEmail(to email: String?) {
        guard let email = email,
            let controller = mailComposer?.makeViewController(email: email) else {
                presentationContext?.present(
                    alert: .localized(.couldNotSendEmail),
                    message: .localized(.couldNotSendEmailMessage)
                )
                
                return
        }
        
        presentationContext?.present(controller)
    }
}
