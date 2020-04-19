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
    private let render: MainRenderType
    private var token: NotificationCenter.Token?
    
    init(
        store: Store<MainState>,
        interactor: MainInteractorType?,
        render: MainRenderType
    ) {
        self.store = store
        self.interactor = interactor
        self.render = render
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
        viewControllers = state.tabMenu.map { item in
            UINavigationController(
                rootViewController: render.rootView(for: item.id).with {
                    $0.tabBarItem = UITabBarItem(
                        title: item.title,
                        image: UIImage(named: item.imageName),
                        tag: item.id.rawValue
                    )
                }
            ).with {
                $0.navigationBar.prefersLargeTitles = true
                $0.navigationBar.topItem?.backBarButtonItem =
                    UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
            }
        }
    }
}

// MARK: - Delegates

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Special handling per tab if needed
        (viewController.contentViewController as? MainSelectable)?.mainDidSelect()
    }
}
