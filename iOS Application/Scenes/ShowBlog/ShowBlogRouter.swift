//
//  ShowBlogRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI

struct ShowBlogRouter: ShowBlogRouterable {
    private let render: SceneRenderType
    private let mailComposer: MailComposerType?
    private let theme: Theme?
    
    weak var viewController: UIViewController?
    
    init(render: SceneRenderType, mailComposer: MailComposerType?, theme: Theme?, viewController: UIViewController?) {
        self.render = render
        self.mailComposer = mailComposer
        self.theme = theme
        self.viewController = viewController
    }
}

extension ShowBlogRouter {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = render.listPosts(params: params)
        viewController?.show(controller)
    }
    
    func showPost(for model: PostsDataViewModel) {
        let controller = render.showPost(for: model.id)
        viewController?.show(controller)
    }
    
    func showPost(for id: Int) {
        let controller = render.showPost(for: id)
        viewController?.show(controller)
    }
}

extension ShowBlogRouter {
    
    func listTerms() {
        let controller = render.listTerms()
        viewController?.show(controller)
    }
}

extension ShowBlogRouter {
    
    func showDisclaimer(url: String?) {
        guard let url = url, let theme = theme else {
            showDisclaimerError()
            return
        }
        
        viewController?.modal(safari: url, theme: theme)
    }
    
    func showDisclaimerError() {
        viewController?.present(
            alert: .localized(.disclaimerNotAvailableErrorTitle),
            message: .localized(.disclaimerNotAvailableErrorMessage)
        )
    }
}

extension ShowBlogRouter {
    
    func show(url: String?) {
        guard let url = url, let theme = theme else { return }
        viewController?.modal(safari: url, theme: theme)
    }
}

extension ShowBlogRouter {
    
    func sendEmail(to email: String?) {
        guard let email = email,
            let controller = mailComposer?.makeViewController(email: email) else {
                viewController?.present(
                    alert: .localized(.couldNotSendEmail),
                    message: .localized(.couldNotSendEmailMessage)
                )
                
                return
        }
        
        viewController?.present(controller)
    }
}
