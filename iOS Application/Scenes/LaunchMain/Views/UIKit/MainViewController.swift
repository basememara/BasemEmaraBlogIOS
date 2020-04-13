//
//  MainViewController.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    private let store: Store<MainState>
    private let interactor: MainInteractorType?
    private var token: NotificationCenter.Token?
    
    init(store: Store<MainState>, interactor: MainInteractorType?) {
        self.store = store
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
}

// MARK: - Configure

private extension MainViewController {
    
    func prepare() {
        delegate = self
        store(in: &token, observer: load)
        interactor?.fetchMenu(for: UIDevice.current.userInterfaceIdiom)
    }
    
    func load(_ state: MainState) {
        viewControllers = state.tabMenu.map(UINavigationController.init)
    }
}

// MARK: - Delegates

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Special handling per tab if needed
        (viewController.contentViewController as? MainSelectable)?.mainDidSelect()
    }
}

// MARK: - Helpers

private extension UINavigationController {
    
    convenience init(_ state: MainAPI.TabMenu) {
        self.init(
            rootViewController: state.view.with {
                $0.tabBarItem = UITabBarItem(
                    title: state.item.title,
                    image: UIImage(named: state.item.imageName),
                    tag: state.item.id.rawValue
                )
            }
        )
        
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.topItem?.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
