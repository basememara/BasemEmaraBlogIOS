//
//  DetailViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class MasterViewController: UITableViewController, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet private var headerView: UIView!
    
    // MARK: - Scene variables
    
    private lazy var router: MasterRoutable = MasterRouter(
        viewController: self,
        mailComposer: dependencies.resolve(),
        constants: dependencies.resolve(),
        theme: dependencies.resolve()
    )
    
    // MARK: - Internal variable
    
    private var collapseDetailViewController = true
    private lazy var constants: ConstantsType = dependencies.resolve()
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Events

private extension MasterViewController {
    
    func configure() {
        splitViewController?.delegate = self
        tableView.tableHeaderView = headerView
    }
}

// MARK: - Interactions

private extension MasterViewController {
    
    @IBAction func socialButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            router.showSocial(for: .github)
        case 2:
            router.showSocial(for: .linkedIn)
        case 3:
            router.showSocial(for: .twitter)
        case 4:
            router.sendEmail(
                subject: .localizedFormat(
                    .emailFeedbackSubject,
                    constants.appDisplayName ?? ""
                )
            )
        default:
            break
        }
    }
}

// MARK: - Nested types

extension MasterViewController: CellIdentifiable {
    
    enum CellIdentifier: String {
        case blog
        case seriesScalableApp
        case seriesSwiftUtilities
        case coursesArchitecture
        case coursesFramework
        case consultingDevelopment
        case consultingMentorship
    }
}

// MARK: - Delegates

extension MasterViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        collapseDetailViewController = false
        
        guard let cell = tableView.cellForRow(at: indexPath),
            let identifier = CellIdentifier(from: cell) else {
                return
        }
        
        switch identifier {
        case .blog:
            router.showBlog()
        case .seriesScalableApp:
            router.showSeriesScalableApp(
                title: cell.textLabel?.text
            )
        case .seriesSwiftUtilities:
            router.showSeriesSwiftUtilities(
                title: cell.textLabel?.text
            )
        case .coursesArchitecture:
            router.showCoursesArchitecture()
        case .coursesFramework:
            router.showCoursesFramework()
        case .consultingDevelopment:
            router.showConsultingDevelopment()
        case .consultingMentorship:
            router.showConsultingMentorship()
        }
    }
}

extension MasterViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Default to master view in compact mode
        // https://useyourloaf.com/blog/split-view-controller-display-modes/
        return collapseDetailViewController
    }
}
