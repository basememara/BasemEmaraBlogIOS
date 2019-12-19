//
//  MainViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamCore

class MainViewController: UITabBarController {
    
    // MARK: - Components
    
    private(set) var model: MainModelType
    private let action: MainActionCreatorType?
    
    // MARK: - Properties
    
    private var token: NotificationCenter.Token?
    
    // MARK: - Lifecycle
    
    init(model: MainModelType, action: MainActionCreatorType?) {
        self.model = model
        self.action = action
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        load()
    }
}

// MARK: - Configure

private extension MainViewController {
    
    func setup() {
        delegate = self
        model.subscribe(self, in: &token)
    }
    
    func load() {
        action?.fetchMenu(
            with: MainAPI.FetchMenuRequest(
                layout: model.layout
            )
        )
    }
    
    func render() {
        viewControllers = model.menu.map {
            TabView(model: $0).render()
        }
    }
}

// MARK: - Delegates

extension MainViewController: ModelObserver {
    
    func newState(model: MainModelType) {
        self.model = model
        
        // Unsubscribe since no need to listen any more
        if !model.menu.isEmpty {
            token = nil
        }
        
        render()
    }
}

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Special handling per tab if needed
        (viewController.contentViewController as? MainSelectable)?.mainDidSelect()
    }
}

// MARK: - Subviews

private extension MainViewController {

    struct TabView {
        let model: MainAPI.Menu
        
        func render() -> UIViewController {
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
