//
//  HomeInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-27.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI

// Scene namespace
enum HomeAPI {}

/// Container of dependencies needed to execute this feature.
protocol HomeCoreType {
    func dependency(with inputs: HomeAPI.RoutableInputs) -> HomeRenderable
    func dependency() -> ConstantsType
    func dependency() -> Theme
}

protocol HomeDisplayable: class, AppDisplayable { // Controller
    
}

protocol HomeRenderable: AppRoutable { // Router
    func showAbout()
    func showPortfolio()
    
    func showSeriesScalableApp(title: String?)
    func showSeriesSwiftUtilities(title: String?)
    
    func showCoursesArchitecture()
    func showCoursesFramework()
    func showConsultingDevelopment()
    func showConsultingMentorship()
    
    func showSocial(for type: Social)
    func sendEmail(subject: String)
}

// MARK: - Request/Response

extension HomeAPI {
    
    struct RoutableInputs {
        weak var viewController: UIViewController?
        weak var listPostsDelegate: ListPostsDelegate?
    }
}
