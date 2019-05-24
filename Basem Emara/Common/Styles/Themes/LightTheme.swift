//
//  LightTheme.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-09-26.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct LightTheme: Theme {
    let tint: UIColor = .blue
    let secondaryTint: UIColor = .orange
    
    let backgroundColor: UIColor = .white
    let separatorColor: UIColor = .lightGray
    let selectionColor: UIColor = .init(rgb: (236, 236, 236))
    let headerColor: UIColor = .lightGray
    
    let labelColor: UIColor = .black
    let secondaryLabelColor: UIColor = .darkGray
    let subtleLabelColor: UIColor = .lightGray
    
    let buttonCornerRadius: CGFloat = 3
    
    let positiveColor: UIColor = .green
    let negativeColor: UIColor = .red
    
    let isDarkStyle: Bool = false
}
