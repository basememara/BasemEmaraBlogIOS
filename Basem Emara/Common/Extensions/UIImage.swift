//
//  UIImage.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Returns the image object associated with the specified filename.
    ///
    /// - Parameter name: Enum case for image name
    convenience init?(named name: ImageName) {
        self.init(named: name.rawValue)
    }
    
    enum ImageName: String {
        case placeholder
        case favoriteEmpty = "favorite-empty"
        case favoriteFilled = "favorite-filled"
        case more = "more-icon"
        case comments = "comments"
    }
}
