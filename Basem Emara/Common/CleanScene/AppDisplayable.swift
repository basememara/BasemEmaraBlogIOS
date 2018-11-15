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
    func endRefreshing()
}

extension AppDisplayable where Self: UIViewController {
    
    func display(error: AppModels.Error) {
        endRefreshing()
        present(alert: error.title, message: error.message)
    }
    
    func endRefreshing() {
        #if !(WIDGET_EXT)
        hideSpinner()
        #endif
    }
}
