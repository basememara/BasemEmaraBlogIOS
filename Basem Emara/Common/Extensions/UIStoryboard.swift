//
//  UIStoryboard.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-11-13.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    /**
     Creates and returns a storyboard object for the specified storyboard resource file in the main bundle of the current application.
     
     - parameter name: The name of the storyboard resource file without the filename extension.
     
     - returns: A storyboard object for the specified file. If no storyboard resource file matching name exists, an exception is thrown.
     */
    convenience init(for name: Storyboard, inBundle bundle: Bundle? = nil) {
        self.init(name: name.rawValue, bundle: bundle)
    }
}
