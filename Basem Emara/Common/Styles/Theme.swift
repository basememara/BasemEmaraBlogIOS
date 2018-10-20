//
//  ThemeStore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-09-26.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit
import SwiftyPress

extension Theme {
    
    func apply(for application: UIApplication) {
        application.keyWindow?.tintColor = tint
        
        UITabBar.appearance().with {
            $0.barStyle = barStyle
            $0.tintColor = tint
        }
        
        UINavigationBar.appearance().with {
            $0.barStyle = barStyle
            $0.tintColor = tint
            $0.titleTextAttributes = [
                .foregroundColor: labelColor
            ]
            $0.largeTitleTextAttributes = [
                .foregroundColor: labelColor
            ]
        }
        
        UIToolbar.appearance().barStyle = barStyle
        
        UICollectionView.appearance().backgroundColor = backgroundColor
        
        UITableView.appearance().with {
            $0.backgroundColor = backgroundColor
            $0.separatorColor = separatorColor
        }
        
        UITableViewCell.appearance().with {
            $0.backgroundColor = .clear
            $0.selectionColor = selectionColor
        }
        
        UITextField.appearance().keyboardAppearance = keyboardAppearance
        
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .backgroundColor = selectionColor
        
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self, UITableViewController.self])
            .backgroundColor = .clear
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .textColor = secondaryLabelColor
        
        ThemedLabel.appearance().textColor = labelColor
        ThemedHeadline.appearance().textColor = labelColor
        ThemedSubhead.appearance().textColor = secondaryLabelColor
        ThemedFootnote.appearance().textColor = subtleLabelColor
        
        ThemedButton.appearance().with {
            $0.borderColor = tint
            $0.borderWidth = 1
            $0.cornerRadius = 3
        }
        
        ThemedImageButton.appearance().with {
            $0.contentHorizontalAlignment = .fill
            $0.contentVerticalAlignment = .fill
            $0.imageView?.contentMode = .scaleAspectFit
        }
        
        ThemedSwitch.appearance().with {
            $0.tintColor = tint
            $0.onTintColor = tint
        }
        
        ThemedSegmentedControl.appearance().tintColor = tint
        
        ThemedView.appearance().backgroundColor = backgroundColor
        
        ThemedSeparator.appearance().with {
            $0.backgroundColor = separatorColor
            $0.alpha = 0.5
        }
        
        ThemedView.appearance(whenContainedInInstancesOf: [LatestPostCollectionViewCell.self]).with {
            $0.backgroundColor = selectionColor
            $0.borderColor = separatorColor
            $0.borderWidth = imageBorderWidthInCell
            $0.cornerRadius = 10
        }
        
        ThemedImage.appearance(whenContainedInInstancesOf: [PopularPostCollectionViewCell.self]).with {
            $0.borderColor = separatorColor
            $0.borderWidth = imageBorderWidthInCell
            $0.cornerRadius = 10
        }
        
        ThemedImage.appearance(whenContainedInInstancesOf: [PickedPostCollectionViewCell.self]).with {
            $0.borderColor = separatorColor
            $0.borderWidth = imageBorderWidthInCell
            $0.cornerRadius = 10
        }
        
        RoundedImageView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).with {
            $0.borderColor = separatorColor
            $0.borderWidth = imageBorderWidthInCell
        }
        
        // Ensure existing views render with new theme
        // https://developer.apple.com/documentation/uikit/uiappearance
        application.windows.reload()
    }
}
