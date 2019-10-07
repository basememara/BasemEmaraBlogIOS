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

struct HomeRouter: HomeRoutable {
    weak var viewController: UIViewController?
    weak var listPostsDelegate: ListPostsDelegate?
    
    private let scenes: SceneModuleType
    private let mailComposer: MailComposerType
    private let constants: ConstantsType
    private let theme: Theme
    
    init(
        viewController: UIViewController?,
        listPostsDelegate: ListPostsDelegate?,
        scenes: SceneModuleType,
        mailComposer: MailComposerType,
        constants: ConstantsType,
        theme: Theme
    ) {
        self.viewController = viewController
        self.listPostsDelegate = listPostsDelegate
        self.scenes = scenes
        self.mailComposer = mailComposer
        self.constants = constants
        self.theme = theme
    }
}

extension HomeRouter {
    
    func showAbout() {
        present(pageSlug: "about", constants: constants, theme: theme)
    }
    
    func showPortfolio() {
        present(pageSlug: "portfolio", constants: constants, theme: theme)
    }
}

extension HomeRouter {
    
    func showSeriesScalableApp(title: String?) {
        let controller = scenes.listPosts(
            params: .init(
                fetchType: .terms([80]),
                title: title,
                sort: seriesSort
            ),
            delegate: listPostsDelegate
        )
        
        viewController?.show(controller)
    }
    
    func showSeriesSwiftUtilities(title: String?) {
        let controller = scenes.listPosts(
            params: .init(
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
        present(safari: "https://iosmentor.io", theme: theme)
    }
    
    func showCoursesFramework() {
        present(safari: "https://iosmentor.io/webinars/swift-frameworks/", theme: theme)
    }
    
    func showConsultingDevelopment() {
        present(safari: "https://zamzam.io", theme: theme)
    }
    
    func showConsultingMentorship() {
        present(safari: "https://iosmentor.io/express/", theme: theme)
    }
}

extension HomeRouter {
    
    func showSocial(for type: Social) {
        showSocial(for: type, theme: theme)
    }
    
    func sendEmail(subject: String) {
        let mailComposerController = mailComposer.makeViewController(
            email: constants.email,
            subject: subject,
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
