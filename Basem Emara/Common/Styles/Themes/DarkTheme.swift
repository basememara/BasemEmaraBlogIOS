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
    let secondaryBackgroundColor: UIColor = .init(rgb: (38, 38, 40))
    let tertiaryBackgroundColor: UIColor = .darkGray
    
    let separatorColor: UIColor = .darkGray
    let opaqueColor: UIColor = .lightGray
    
    let labelColor: UIColor = .white
    let secondaryLabelColor: UIColor = .lightGray
    let tertiaryLabelColor: UIColor = .lightGray
    let quaternaryLabelColor: UIColor = .darkGray
    let placeholderLabelColor: UIColor = .darkGray
    
    let buttonCornerRadius: CGFloat = 3
    
    let positiveColor: UIColor = .green
    let negativeColor: UIColor = .red
    
    let isDarkStyle: Bool = true
}
