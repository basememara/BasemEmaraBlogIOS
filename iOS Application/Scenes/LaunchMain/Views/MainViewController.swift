//
//  MainViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftyPress
import ZamzamCore

class MainViewController: UITabBarController {
    
    // MARK: - Components
    
    private(set) var model: MainModelType
    private let action: MainActionCreatorType?
    
    // MARK: - Properties
    
    private var token: NotificationCenter.Token?
    
    // MARK: - Lifecycle
    
    init(
        model: MainModelType,
        action: MainActionCreatorType?
    ) {
        self.model = model
        self.action = action
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
}

// MARK: - Setup

private extension MainViewController {
    
    func configure() {
        delegate = self
        model.subscribe(self, in: &token)
    }
    
    func loadData() {
        action?.fetchMenu(
            with: MainAPI.FetchMenuRequest(layout: model.layout)
        )
    }
}

// MARK: - Delegates

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Special handling per tab if needed
        (viewController.contentViewController as? MainSelectable)?.mainDidSelect()
    }
}

extension MainViewController: ModelObserver {
    
    func newState(model: MainModelType) {
        self.model = model
        
        // Unsubscribe since no need to listen any more
        if !model.menu.isEmpty {
            token = nil
        }
        
        // Construct view
        viewControllers = model.menu.map { model in
            UINavigationController(
                rootViewController: model.scene().with {
                    $0.tabBarItem = UITabBarItem(
                        title: model.title,
                        image: UIImage(named: model.imageName),
                        tag: model.id
                    )
                }
            )
            .with {
                guard let prefersLargeTitles = model.prefersLargeTitles else { return }
                $0.navigationBar.prefersLargeTitles = prefersLargeTitles
            }
        }
    }
}
