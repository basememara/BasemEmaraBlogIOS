//
//  HomeRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI

struct HomeRouter: HomeRouterType {
    private let render: SceneRenderType
    private let mailComposer: MailComposerType
    private let constants: ConstantsType
    private let theme: Theme
    
    weak var viewController: UIViewController?
    weak var listPostsDelegate: ListPostsDelegate?
    
    init(
        render: SceneRenderType,
        viewController: UIViewController?,
        listPostsDelegate: ListPostsDelegate?,
        mailComposer: MailComposerType,
        constants: ConstantsType,
        theme: Theme
    ) {
        self.render = render
        self.viewController = viewController
        self.listPostsDelegate = listPostsDelegate
        self.mailComposer = mailComposer
        self.constants = constants
        self.theme = theme
    }
}

extension HomeRouter {
    
    func showAbout() {
        viewController?.modal(
            pageSlug: "about",
            constants: constants,
            theme: theme
        )
    }
    
    func showPortfolio() {
        viewController?.modal(
            pageSlug: "portfolio",
            constants: constants,
            theme: theme
        )
    }
}

extension HomeRouter {
    
    func showSeriesScalableApp(title: String?) {
        let controller = render.listPosts(
            params: ListPostsAPI.Params(
                fetchType: .terms([80]),
                title: title,
                sort: seriesSort
            ),
            delegate: listPostsDelegate
        )
        
        viewController?.show(controller)
    }
    
    func showSeriesSwiftUtilities(title: String?) {
        let controller = render.listPosts(
            params: ListPostsAPI.Params(
                fetchType: .terms([71]),
                title: title,
                sort: seriesSort
            ),
            delegate: listPostsDelegate
        )
        
        viewController?.show(controller)
    }
    
    private func seriesSort(_ post1: PostType, _ post2: PostType) -> Bool {
        guard let lhs = Int(post1.meta["_series_part"] ?? ""),
            let rhs = Int(post2.meta["_series_part"] ?? "") else {
                return false
        }

        return lhs < rhs
    }
}

extension HomeRouter {
    
    func showCoursesArchitecture() {
        viewController?.modal(
            safari: "https://iosmentor.io",
            theme: theme
        )
    }
    
    func showCoursesFramework() {
        viewController?.modal(
            safari: "https://iosmentor.io/webinars/swift-frameworks/",
            theme: theme
        )
    }
    
    func showConsultingDevelopment() {
        viewController?.modal(
            safari: "https://zamzam.io",
            theme: theme
        )
    }
    
    func showConsultingMentorship() {
        viewController?.modal(
            safari: "https://iosmentor.io/express/",
            theme: theme
        )
    }
}

extension HomeRouter {
    
    func show(social: Social) {
        viewController?.show(social: social, theme: theme)
    }
    
    func sendEmail() {
        let mailComposerController = mailComposer.makeViewController(
            email: constants.email,
            subject: .localizedFormat(
                .emailFeedbackSubject,
                constants.appDisplayName ?? ""
            ),
            body: nil,
            isHTML: true,
            attachment: nil
        )
        
        guard let controller = mailComposerController else {
            UIWindow.current?.visibleViewController?.present(
                alert: .localized(.couldNotSendEmail),
                message: .localized(.couldNotSendEmailMessage)
            )
            
            return
        }
        
        UIWindow.current?.visibleViewController?.present(controller)
    }
}
