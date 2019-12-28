//
//  HomeInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-27.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol HomeModelType: ModelType {
    
}

protocol HomeActionCreatorType: ActionCreatorType {
    
}

protocol HomeRouterType {
    func showAbout()
    func showPortfolio()
    
    func showSeriesScalableApp(title: String?)
    func showSeriesSwiftUtilities(title: String?)
    
    func showCoursesArchitecture()
    func showCoursesFramework()
    func showConsultingDevelopment()
    func showConsultingMentorship()
    
    func show(social: Social)
    func sendEmail()
}

// MARK: - Request/Response

enum HomeAPI {}
