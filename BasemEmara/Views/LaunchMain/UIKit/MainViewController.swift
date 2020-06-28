//
//  MainViewController.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI

class MainViewController: UITabBarController {
    private let state: MainState
    private let interactor: MainInteractable?
    private let render: MainRenderable
    
    init(
        state: MainState,
        interactor: MainInteractable?,
        render: MainRenderable
    ) {
        self.state = state
        self.interactor = interactor
        self.render = render
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingRemoved else { return }
        state.unsubscribe()
    }
}

// MARK: - Configure

private extension MainViewController {
    
    func prepare() {
        delegate = self
        state.subscribe(load)
    }
    
    func fetch() {
        interactor?.fetchMenu(for: UIDevice.current.userInterfaceIdiom)
    }
    
    func load(_ result: StateChange<MainState>) {
        viewControllers = state.tabMenu.map { item in
            UINavigationController(
                rootViewController: render.rootView(for: item.id).apply {
                    $0.tabBarItem = UITabBarItem(
                        title: item.title,
                        image: UIImage(named: item.imageName),
                        tag: item.id.rawValue
                    )
                }
            ).apply {
                $0.navigationBar.prefersLargeTitles = true
                $0.navigationBar.topItem?.backBarButtonItem = .makeBackBarButtonItem()
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

// MARK: - Preview

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct MainViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        MainViewController(
            state: Preview.mainState,
            interactor: nil,
            render: MainViewController_Preview.MockRender()
        ).previews
    }
    
    struct MockRender: MainRenderable {
        func rootView(for menu: MainAPI.Menu) -> UIViewController { UIViewController() }
        func postView(for id: Int) -> UIViewController { UIViewController() }
    }
}
#endif
