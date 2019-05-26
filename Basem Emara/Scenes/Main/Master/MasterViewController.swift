//
//  MasterViewController.swift
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
            router.startBlog()
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
        
        // Dismiss master view controller
        // https://stackoverflow.com/a/27399688
        if splitViewController?.displayMode == .primaryOverlay,
            let barButtonItem = splitViewController?.displayModeButtonItem,
            let action = barButtonItem.action {
                UIApplication.shared.sendAction(action, to: barButtonItem.target, from: nil, for: nil)
        }
    }
}

extension MasterViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Default to master view in compact mode
        // https://useyourloaf.com/blog/split-view-controller-display-modes/
        return collapseDetailViewController
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard splitViewController.isCollapsed else {
            // Display within detail tab bar view controller
            router.show(tab: .dashboard) {
                $0.show(vc)
            }
            
            return true
        }
        
        vc.viewWillAppear {
            $0?.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        // Push to master view controller
        show(vc)
        return true
    }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        dismiss()
    }
}
