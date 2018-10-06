//
//  Theme.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-09-22.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct DarkTheme: Theme {
    let tint: UIColor = .init(rgb: (49, 169, 234))
    let secondaryTint: UIColor = .init(rgb: (137, 167, 167))
    
    let backgroundColor: UIColor = .black
    let separatorColor: UIColor = .lightGray
    let selectionColor: UIColor = .init(rgb: (38, 38, 40))
    
    let labelColor: UIColor = .white
    let secondaryLabelColor: UIColor = .lightGray
    let subtleLabelColor: UIColor = .darkGray
    
    let imageBorderWidthInCell: CGFloat = 0
    
    let barStyle: UIBarStyle = .black
}
