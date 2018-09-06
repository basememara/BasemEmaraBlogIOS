//
//  UIApplication.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-08-27.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

extension UIApplication {
    
    /**
     Get application window regardless of position in app lifecycle.
     */
    static func getWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
            ?? (UIApplication.shared.delegate as? AppDelegate)?.window
    }
}
