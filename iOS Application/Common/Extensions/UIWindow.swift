//
//  UIApplication.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

extension UIWindow {
    
    /// Returns the window object for your app.
    static var current: UIWindow? {
        guard #available(iOS 13, *) else {
            return UIApplication.shared.keyWindow
        }
        
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
