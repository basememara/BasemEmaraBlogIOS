//
//  MoreViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ShowMoreViewController: UITableViewController {
    
    // MARK: - Dependencies
    
    var core: ShowMoreCoreType?
    
    private(set) lazy var router: ShowMoreRouterable? = core?.dependency(with: self)
    private lazy var constants: ConstantsType? = core?.dependency()
}

// MARK: - Interactions

private extension ShowMoreViewController {
    
    @IBAction func twitterButtonTapped() {
        router?.show(social: .twitter)
    }
    
    @IBAction func linkedInButtonTapped() {
        router?.show(social: .linkedIn)
    }
    
    @IBAction func githubButtonTapped() {
        router?.show(social: .github)
    }
}

// MARK: - Subtypes

extension ShowMoreViewController: CellIdentifiable {
    
    enum CellIdentifier: String {
        case subscribe
        case feedback
        case work
        case rate
        case share
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
            router?.showSubscribe()
        case .feedback:
            router?.sendFeedback(
                subject: .localizedFormat(
                    .emailFeedbackSubject,
                    constants?.appDisplayName ?? ""
                )
            )
        case .work:
            router?.showWorkWithMe()
        case .rate:
            router?.showRateApp()
        case .share:
            router?.share(
                appURL: constants?.itunesURL ?? "",
                message: .localizedFormat(.shareAppMessage, constants?.appDisplayName ?? ""),
                popoverFrom: cell
            )
        case .settings:
            router?.showSettings()
        case .developedBy:
            router?.showDevelopedBy()
        }
    }
}
