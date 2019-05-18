//
//  SceneDependable.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

/// Dependency injector for overriding concrete scene factories.
/// Inject delegates, parameters, interactors, presenters, routers,
/// and so forth to override behavior in the next scene.
protocol SceneDependable {
    func startMain() -> UIViewController
    func showDashboard() -> UIViewController
}
