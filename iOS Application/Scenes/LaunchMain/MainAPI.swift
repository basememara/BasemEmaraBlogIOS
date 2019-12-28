//
//  MainAPI.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//

import UIKit

protocol MainModelType: ModelType {
    var menu: [MainAPI.Menu] { get }
    var layout: MainAPI.Layout { get }
}

protocol MainActionCreatorType: ActionCreatorType {
    func fetchMenu(with request: MainAPI.FetchMenuRequest)
}

protocol MainRouterType {
    func showPost(for id: Int)
}

/// Used to notify the controller was selected from the main controller
protocol MainSelectable {
    func mainDidSelect()
}

// MARK: - Request/Response

enum MainAPI {
    
    struct FetchMenuRequest {
        let layout: Layout
    }
    
    enum Layout {
        case pad
        case phone
    }
    
    /// Data representation of the main menu and content
    struct Menu {
        let id: Int
        let title: String
        let imageName: String
        let prefersLargeTitles: Bool?
        let scene: () -> UIViewController
    }
}
