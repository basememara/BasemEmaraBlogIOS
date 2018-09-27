//
//  Theme.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-09-22.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

public struct DarkThemeStore: ThemeStore {
    let tint: UIColor = .init(rgb: (49, 169, 234))
    let secondaryTint: UIColor = .init(rgb: (137, 167, 167))
    
    let backgroundColor: UIColor = .black
    let separatorColor: UIColor = .lightGray
    let selectionColor: UIColor = .init(rgb: (38, 38, 40))
    
    let labelColor: UIColor = .white
    let secondaryLabelColor: UIColor = .lightGray
    let subtleLabelColor: UIColor = .darkGray
    
    let barStyle: UIBarStyle = .black
}

public extension DarkThemeStore {
    
    func apply(for application: UIApplication) {
        application.keyWindow?.tintColor = tint
        
        UITabBar.appearance().barStyle = barStyle
        
        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().tintColor = tint
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: labelColor
        ]
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [
                .foregroundColor: labelColor
            ]
        }
        
        UICollectionView.appearance().backgroundColor = backgroundColor
        UITableView.appearance().backgroundColor = backgroundColor
        UITableView.appearance().separatorColor = separatorColor
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionColor = selectionColor
        
        AppButton.appearance().borderColor = tint
        AppButton.appearance().borderWidth = 1
        AppButton.appearance().cornerRadius = 3
        
        AppImageButton.appearance().tintColor = secondaryTint
        
        AppLabel.appearance().textColor = labelColor
        AppSubhead.appearance().textColor = secondaryLabelColor
        AppFootnote.appearance().textColor = subtleLabelColor
        
        AppView.appearance().backgroundColor = backgroundColor
        AppSeparator.appearance().backgroundColor = separatorColor
        AppSeparator.appearance().alpha = 0.5
        
        AppView.appearance(whenContainedInInstancesOf: [LatestPostCollectionViewCell.self]).with {
            $0.backgroundColor = selectionColor
            $0.cornerRadius = 10
        }
        
        UIImageView.appearance(whenContainedInInstancesOf: [PopularPostCollectionViewCell.self]).with {
            $0.cornerRadius = 10
        }
        
        UIImageView.appearance(whenContainedInInstancesOf: [PickedPostCollectionViewCell.self]).with {
            $0.cornerRadius = 10
        }
    }
}
