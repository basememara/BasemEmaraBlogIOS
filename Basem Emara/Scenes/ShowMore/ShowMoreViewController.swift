//
//  MoreViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class ShowMoreViewController: UITableViewController, HasDependencies {
    
    // MARK: - Scene variables
    
    private(set) lazy var router: ShowMoreRoutable = ShowMoreRouter(
        viewController: self,
        constants: dependencies.resolve(),
        mailComposer: dependencies.resolve(),
        theme: dependencies.resolve()
    )
    
    // MARK: - Internal variable
    
    private lazy var constants: ConstantsType = dependencies.resolve()
}

// MARK: - Interactions

private extension ShowMoreViewController {
    
    @IBAction func twitterButtonTapped() {
        router.showSocial(for: .twitter)
    }
    
    @IBAction func linkedInButtonTapped() {
        router.showSocial(for: .linkedIn)
    }
    
    @IBAction func githubButtonTapped() {
        router.showSocial(for: .github)
    }
}

// MARK: - Nested types

extension ShowMoreViewController: CellIdentifiable {
    
    enum CellIdentifier: String {
        case subscribe
        case feedback
        case work
        case rate
        case share
        case notifications
        case settings
        case developedBy
    }
}

// MARK: - Delegates

extension ShowMoreViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath),
            let identifier = CellIdentifier(from: cell) else {
                return
        }
        
        switch identifier {
        case .subscribe:
            router.showSubscribe()
        case .feedback:
            router.sendFeedback(
                subject: .localizedFormat(
                    .emailFeedbackSubject,
                    constants.appDisplayName ?? ""
                )
            )
        case .work:
            router.showWorkWithMe()
        case .rate:
            router.showRateApp()
        case .share:
            let message: String = .localizedFormat(.shareAppMessage, constants.appDisplayName ?? "")
            let share = [message, constants.itunesURL]
            present(activities: share, popoverFrom: cell)
        case .notifications:
            (UIApplication.shared.delegate as? AppDelegate)?.lazyModules
                .compactMap { $0 as? NotificationApplicationModule }
                .first?
                .register { [weak self] granted in
                    // TODO: Move to tutorial and localize
                    guard granted else {
                        self?.present(alert: "Please enable any time from iOS settings.")
                        return
                    }
                    
                    self?.present(alert: "You have registered to receive notifications.")
                }
        case .settings:
            router.showSettings()
        case .developedBy:
            router.showDevelopedBy()
        }
    }
}
