//
//  HomeInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-27.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

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
