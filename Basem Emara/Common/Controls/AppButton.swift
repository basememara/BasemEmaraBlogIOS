//
//  AppButton.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

class AppButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TODO: Implement enum styles
        borderColor = .tint
        borderWidth = 1
        cornerRadius = 3
    }
}
