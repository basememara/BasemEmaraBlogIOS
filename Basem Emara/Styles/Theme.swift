//
//  ThemeStore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-09-26.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

protocol Theme {
    var tint: UIColor { get }
    var secondaryTint: UIColor { get }
    
    var backgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var selectionColor: UIColor { get }
    
    var labelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var subtleLabelColor: UIColor { get }
    
    var barStyle: UIBarStyle { get }
    
    func apply(for application: UIApplication)
    func extend()
}

extension Theme {
    
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
        
        extend()
    }
    
    func extend() {
        // Optionally extend theme
    }
}
