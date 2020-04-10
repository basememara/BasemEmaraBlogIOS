//
//  Theme.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-09-22.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import CoreGraphics
import SwiftyPress
import UIKit.UITraitCollection
import ZamzamCore

struct AppTheme: Theme {
    let tint = ColorTypeAlias(named: "tint") ?? .init(rgb: (49, 169, 234))
    let secondaryTint = ColorTypeAlias(named: "secondaryTint") ?? .init(rgb: (137, 167, 167))
    
    let backgroundColor = ColorTypeAlias(named: "backgroundColor") ?? .black
    let secondaryBackgroundColor = ColorTypeAlias(named: "secondaryBackgroundColor") ?? .init(rgb: (28, 28, 30))
    let tertiaryBackgroundColor = ColorTypeAlias(named: "tertiaryBackgroundColor") ?? .init(rgb: (44, 44, 46))
    let quaternaryBackgroundColor = ColorTypeAlias(named: "quaternaryBackgroundColor") ?? .init(rgb: (58, 58, 60))
    
    let separatorColor = ColorTypeAlias(named: "separatorColor") ?? .darkGray
    let opaqueColor = ColorTypeAlias(named: "opaqueColor") ?? .lightGray
    
    let labelColor = ColorTypeAlias(named: "labelColor") ?? .white
    let secondaryLabelColor = ColorTypeAlias(named: "secondaryLabelColor") ?? .init(rgb: (242, 242, 247))
    let tertiaryLabelColor = ColorTypeAlias(named: "tertiaryLabelColor") ?? .init(rgb: (229, 229, 234))
    let quaternaryLabelColor = ColorTypeAlias(named: "quaternaryLabelColor") ?? .init(rgb: (209, 209, 214))
    let placeholderLabelColor = ColorTypeAlias(named: "placeholderLabelColor") ?? .darkGray
    
    let buttonCornerRadius: CGFloat = 3
    
    let positiveColor = ColorTypeAlias(named: "positiveColor") ?? .green
    let negativeColor = ColorTypeAlias(named: "negativeColor") ?? .red
    
    let isDarkStyle: Bool = {
        guard #available(iOS 13.0, *) else { return false }
        return UITraitCollection.current.userInterfaceStyle == .dark
    }()
}
