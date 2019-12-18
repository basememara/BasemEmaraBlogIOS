//
//  MainAPI.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//

import UIKit
import ZamzamUI

// Scene namespace
enum MainAPI {}

protocol MainModelType: ModelType {
    var menu: [MainAPI.Menu] { get }
    var layout: UIUserInterfaceIdiom { get }
}

protocol MainActionType: ActionType {
    
}

protocol MainActionCreatorType: ActionCreatorType {
    func fetchMenu(with request: MainAPI.FetchMenuRequest)
}

protocol MainReducerType: ReducerType {
    
}

protocol MainRouterType {
    func home() -> UIViewController
    func showPost(for id: Int)
}

/// Used to notify the controller was selected from the main controller
protocol MainSelectable {
    func mainDidSelect()
}

// MARK: - Request/Response

extension MainAPI {
    
    struct FetchMenuRequest {
        let layout: UIUserInterfaceIdiom
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
