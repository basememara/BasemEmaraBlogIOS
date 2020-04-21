//
//  UIImageView.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-21.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSBundle
import UIKit.UIImageView

extension UIImageView {
    
    /// Returns an image view initialized with the specified image.
    ///
    /// - Parameters:
    ///   - named: The name of the image.
    ///   - bundle: The bundle containing the image file or asset catalog. Specify nil to search the app's main bundle.
    convenience init(imageNamed name: UIImage.ImageName, inBundle bundle: Bundle? = nil) {
        self.init(image: UIImage(named: name, inBundle: bundle))
    }
}
