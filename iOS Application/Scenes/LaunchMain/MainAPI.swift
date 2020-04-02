//
//  MainAPI.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//

import UIKit.UIViewController

protocol MainReducerType: ReducerType {}

protocol MainRenderType {
    func home() -> UIViewController
    func showBlog() -> UIViewController
    func listFavorites() -> UIViewController
    func searchPosts() -> UIViewController
    func showMore() -> UIViewController
    func showPost(for id: Int) -> UIViewController
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
    
    struct TabItem {
        let type: Menu
        let title: String
        let imageName: String
        let view: () -> UIViewController?
    }
}
