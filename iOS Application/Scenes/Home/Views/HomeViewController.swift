//
//  HomeViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

class HomeViewController: UITableViewController {
    
    // MARK: - Controls
    
    @IBOutlet private var headerView: UIView!
    
    // MARK: - Dependencies
    
    var core: HomeCoreType?
    
    private lazy var render: HomeRenderable? = core?.dependency(
        with: HomeAPI.RoutableInputs(
            viewController: self,
            listPostsDelegate: splitViewController as? ListPostsDelegate
        )
    )
    
    private lazy var constants: ConstantsType? = core?.dependency()
    private lazy var theme: Theme? = core?.dependency()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Setup

private extension HomeViewController {
    
    func configure() {
        tableView.tableHeaderView = headerView
    }
}

// MARK: - Interactions

private extension HomeViewController {
    
    @IBAction func socialButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            render?.showSocial(for: .github)
        case 2:
            render?.showSocial(for: .linkedIn)
        case 3:
            render?.showSocial(for: .twitter)
        case 4:
            render?.sendEmail(
                subject: .localizedFormat(
                    .emailFeedbackSubject,
                    constants?.appDisplayName ?? ""
                )
            )
        default:
            break
        }
    }
}

// MARK: - Scene

extension HomeViewController: HomeDisplayable {
    
}

// MARK: - Subtypes

extension HomeViewController: CellIdentifiable {
    
    enum CellIdentifier: String {
        case about
        case portfolio
        case seriesScalableApp
        case seriesSwiftUtilities
        case coursesArchitecture
        case coursesFramework
        case consultingDevelopment
        case consultingMentorship
    }
}

// MARK: - Delegates

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath),
            let identifier = CellIdentifier(from: cell) else {
                return
        }
        
        switch identifier {
        case .about:
            render?.showAbout()
        case .portfolio:
            render?.showPortfolio()
        case .seriesScalableApp:
            render?.showSeriesScalableApp(
                title: cell.textLabel?.text
            )
        case .seriesSwiftUtilities:
            render?.showSeriesSwiftUtilities(
                title: cell.textLabel?.text
            )
        case .coursesArchitecture:
            render?.showCoursesArchitecture()
        case .coursesFramework:
            render?.showCoursesFramework()
        case .consultingDevelopment:
            render?.showConsultingDevelopment()
        case .consultingMentorship:
            render?.showConsultingMentorship()
        }
    }
}
