//
//  SceneConfigurator.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

struct SceneConfigurator: SceneDependable {
    
}

extension SceneConfigurator {
    
    func startMain() -> UIViewController {
        return .make(fromStoryboard: Storyboard.main.rawValue)
    }
}

extension SceneConfigurator {
    
    func showDashboard() -> UIViewController {
        return .make(fromStoryboard: Storyboard.showDashboard.rawValue)
    }
}

extension SceneConfigurator {
    
    /// Tab identifiers for routing
    enum Tab: Int {
        case dashboard = 0
        case favorites = 1
        case search = 2
        case more = 3
    }
    
    /// Storyboard identifiers for routing
    enum Storyboard: String {
        case main = "Main"
        case showDashboard = "ShowDashboard"
        case listPosts = "ListPosts"
        case showPost = "ShowPost"
        case previewPost = "PreviewPost"
        case listTerms = "ListTerms"
        case showSettings = "ShowSettings"
    }

}
