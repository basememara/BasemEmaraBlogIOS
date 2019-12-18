//
//  AppDisplayable.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import UIKit

/// Super displayer for implementing global extensions.
protocol AppDisplayable {
    
    /// Display error details.
    ///
    /// - Parameter error: The error details to present.
    func display(error: AppAPI.Error)
    
    /// Hides spinners, loaders, and anything else
    func endRefreshing()
}

extension AppDisplayable where Self: UIViewController {
    
    /// Display a native alert controller modally.
    ///
    /// - Parameter error: The error details to present.
    func display(error: AppAPI.Error) {
        // Force in next runloop via main queue since view hierachy may not be loaded yet
        DispatchQueue.main.async { [weak self] in
            self?.endRefreshing()
            self?.present(alert: error.title, message: error.message)
        }
    }
}

extension AppDisplayable where Self: UIViewController {
    
    func endRefreshing() {
        // Override individually
    }
}
