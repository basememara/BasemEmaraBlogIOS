//
//  MainAPI.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIDevice
import UIKit.UIViewController
#if canImport(SwiftUI)
import SwiftUI
#endif

protocol MainInteractorType: InteractorType {
    func fetchMenu(for idiom: UIUserInterfaceIdiom)
}

protocol MainPresenterType: PresenterType {
    func display(menu: [MainAPI.TabItem])
    func displayPost(for id: Int) -> UIViewController
}

/// Used to notify the controller was selected from the main controller.
protocol MainSelectable {
    func mainDidSelect()
}

// MARK: - Namespace

enum MainAPI {
    
    enum Menu: Int {
        case home
        case blog
        case favorites
        case search
        case more
    }
    
    struct TabItem: Identifiable {
        let id: Menu
        let title: String
        let imageName: String
    }
    
    struct TabMenu {
        let item: TabItem
        
        /// View to store UIKit and SwiftUI reference
        private let anyView: Any
    }
}

extension MainAPI.TabMenu: Identifiable {
    var id: MainAPI.Menu { item.id }
}

// Support between UIKit and SwiftUI simultaneously
// https://stackoverflow.com/a/43503888
extension MainAPI.TabMenu {
    
    init(item: MainAPI.TabItem, view: Any) {
        self.item = item
        self.anyView = view
    }
    
    func view() -> UIViewController? {
        anyView as? UIViewController
    }
    
    @available(iOS 13.0, *)
    func view() -> ViewRepresentable? {
        anyView as? ViewRepresentable
    }
}
