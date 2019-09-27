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
protocol HomeModuleType {
    func component(with inputs: HomeAPI.RoutableInputs) -> HomeRoutable
    func component() -> ConstantsType
    func component() -> Theme
}

protocol HomeDisplayable: class, AppDisplayable { // Controller
    
}

protocol HomeRoutable: AppRoutable { // Router
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

extension HomeAPI {
    
    struct RoutableInputs {
        weak var viewController: UIViewController?
        weak var listPostsDelegate: ListPostsDelegate?
    }
}
