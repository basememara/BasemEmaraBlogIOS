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
    let secondaryBackgroundColor: UIColor = .init(rgb: (28, 28, 30))
    let tertiaryBackgroundColor: UIColor = .init(rgb: (44, 44, 46))
    let quaternaryBackgroundColor: UIColor = .init(rgb: (58, 58, 60))
    
    let separatorColor: UIColor = .darkGray
    let opaqueColor: UIColor = .lightGray
    
    let labelColor: UIColor = .white
    let secondaryLabelColor: UIColor = .init(rgb: (242, 242, 247))
    let tertiaryLabelColor: UIColor = .init(rgb: (229, 229, 234))
    let quaternaryLabelColor: UIColor = .init(rgb: (209, 209, 214))
    let placeholderLabelColor: UIColor = .darkGray
    
    let buttonCornerRadius: CGFloat = 3
    
    let positiveColor: UIColor = .green
    let negativeColor: UIColor = .red
    
    let isDarkStyle: Bool = true
}
