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
    let tint = PlatformColor(named: "tint") ?? .init(rgb: (49, 169, 234))
    let secondaryTint = PlatformColor(named: "secondaryTint") ?? .init(rgb: (137, 167, 167))
    
    let backgroundColor = PlatformColor(named: "backgroundColor") ?? .black
    let secondaryBackgroundColor = PlatformColor(named: "secondaryBackgroundColor") ?? .init(rgb: (28, 28, 30))
    let tertiaryBackgroundColor = PlatformColor(named: "tertiaryBackgroundColor") ?? .init(rgb: (44, 44, 46))
    let quaternaryBackgroundColor = PlatformColor(named: "quaternaryBackgroundColor") ?? .init(rgb: (58, 58, 60))
    
    let separatorColor = PlatformColor(named: "separatorColor") ?? .darkGray
    let opaqueColor = PlatformColor(named: "opaqueColor") ?? .lightGray
    
    let labelColor = PlatformColor(named: "labelColor") ?? .white
    let secondaryLabelColor = PlatformColor(named: "secondaryLabelColor") ?? .init(rgb: (242, 242, 247))
    let tertiaryLabelColor = PlatformColor(named: "tertiaryLabelColor") ?? .init(rgb: (229, 229, 234))
    let quaternaryLabelColor = PlatformColor(named: "quaternaryLabelColor") ?? .init(rgb: (209, 209, 214))
    let placeholderLabelColor = PlatformColor(named: "placeholderLabelColor") ?? .darkGray
    
    let buttonCornerRadius: CGFloat = 3
    
    let positiveColor = PlatformColor(named: "positiveColor") ?? .green
    let negativeColor = PlatformColor(named: "negativeColor") ?? .red
    
    let isDarkStyle: Bool = {
        guard #available(iOS 13, *) else { return false }
        return UITraitCollection.current.userInterfaceStyle == .dark
    }()
}
