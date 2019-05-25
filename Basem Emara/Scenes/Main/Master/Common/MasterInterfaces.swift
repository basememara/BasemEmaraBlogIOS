//
//  MasterInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

protocol MasterDisplayable: class, AppDisplayable { // Controller
    
}

protocol MasterRoutable: AppRoutable { // Router
    func showBlog()
    
    func showSeriesScalableApp(title: String?)
    func showSeriesSwiftUtilities(title: String?)
    
    func showCoursesArchitecture()
    func showCoursesFramework()
    func showConsultingDevelopment()
    func showConsultingMentorship()
    
    func showSocial(for type: Social)
    func sendEmail(subject: String)
}
