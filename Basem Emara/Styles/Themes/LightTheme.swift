//
//  LightTheme.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-09-26.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

struct LightTheme: Theme {
    let tint: UIColor = .blue
    let secondaryTint: UIColor = .orange
    
    let backgroundColor: UIColor = .white
    let separatorColor: UIColor = .lightGray
    let selectionColor: UIColor = .init(rgb: (236, 236, 236))
    
    let labelColor: UIColor = .black
    let secondaryLabelColor: UIColor = .darkGray
    let subtleLabelColor: UIColor = .lightGray
    
    let barStyle: UIBarStyle = .default
}

extension LightTheme {
    
    func extend() {
        UIImageView.appearance(whenContainedInInstancesOf: [UICollectionViewCell.self]).with {
            $0.borderColor = separatorColor
            $0.borderWidth = 1
        }
        
        UIImageView.appearance(whenContainedInInstancesOf: [UIButton.self, UICollectionViewCell.self]).with {
            $0.borderWidth = 0
        }
        
        UIImageView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).with {
            $0.borderColor = separatorColor
            $0.borderWidth = 1
        }
        
        UIImageView.appearance(whenContainedInInstancesOf: [UIButton.self, UITableViewCell.self]).with {
            $0.borderWidth = 0
        }
    }
}
