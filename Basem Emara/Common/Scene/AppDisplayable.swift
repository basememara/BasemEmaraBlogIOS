//
//  AppDisplayable.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

protocol AppDisplayable {
    func display(error: AppModels.Error)
}

extension AppDisplayable {
    
    func display(error: AppModels.Error) {
        // Overridden by view controller for presenting alerts
    }
}

extension AppDisplayable where Self: UIViewController {
    
    func display(error: AppModels.Error) {
        present(alert: error.title, message: error.message)
    }
}
