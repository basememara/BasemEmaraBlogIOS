//
//  MasterRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

struct MasterRouter: MasterRoutable, HasScenes {
    weak var viewController: UIViewController?
    
    private let mailComposer: MailComposerType
    private let constants: ConstantsType
    private let theme: Theme
    
    init(
        viewController: UIViewController,
        mailComposer: MailComposerType,
        constants: ConstantsType,
        theme: Theme
    ) {
        self.viewController = viewController
        self.mailComposer = mailComposer
        self.constants = constants
        self.theme = theme
    }
}

extension MasterRouter {
    
    func showBlog() {
        show(tab: .dashboard)
    }
}

extension MasterRouter {
    
    func showSeriesScalableApp(title: String?) {
        show(tab: .dashboard) {
            let controller = self.scenes.listPosts(
                params: .init(
                    fetchType: .terms([80]),
                    title: title,
                    sort: self.seriesSort
                )
            )
            
            $0.show(controller)
        }
    }
    
    func showSeriesSwiftUtilities(title: String?) {
        show(tab: .dashboard) {
            let controller = self.scenes.listPosts(
                params: .init(
                    fetchType: .terms([71]),
                    title: title,
                    sort: self.seriesSort
                )
            )
            
            $0.show(controller)
        }
    }
    
    private func seriesSort(_ post1: PostType, _ post2: PostType) -> Bool {
        guard let lhs = Int(post1.meta["_series_part"] ?? ""),
            let rhs = Int(post2.meta["_series_part"] ?? "") else {
                return false
        }

        return lhs < rhs
    }
}

extension MasterRouter {
    
    func showCoursesArchitecture() {
        viewController?.present(
            safari: "https://iosmentor.io",
            theme: theme
        )
    }
    
    func showCoursesFramework() {
        viewController?.present(
            safari: "https://iosmentor.io/webinars/swift-frameworks/",
            theme: theme
        )
    }
    
    func showConsultingDevelopment() {
        viewController?.present(
            safari: "https://zamzam.io",
            theme: theme
        )
    }
    
    func showConsultingMentorship() {
        viewController?.present(
            safari: "https://iosmentor.io/express/",
            theme: theme
        )
    }
}

extension MasterRouter {
    
    func showSocial(for type: Social) {
        showSocial(for: type, theme: theme)
    }
    
    func sendEmail(subject: String) {
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
