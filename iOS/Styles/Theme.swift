//
//  Theme.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-10-26.
//

import Foundation
import UIKit
import ZamzamUI
import SwiftyPress

extension Theme {
    
    func apply(for window: UIWindow?) {
        window?.tintColor = tint
        
        applyPlatform()
        applyThemed()
        applyCustom()
        applyScenes()
    }
}

private extension Theme {
    
    func applyPlatform() {
        UITabBar.appearance().apply {
            $0.tintColor = tint
        }
        
        UINavigationBar.appearance().apply {
            $0.tintColor = tint
            $0.titleTextAttributes = [
                .foregroundColor: labelColor
            ]
            $0.largeTitleTextAttributes = [
                .foregroundColor: labelColor
            ]
        }
        
        UIToolbar.appearance().apply {
            $0.tintColor = tint
        }
        
        UICollectionView.appearance().backgroundColor = backgroundColor
        
        UITableView.appearance().apply {
            $0.backgroundColor = backgroundColor
            $0.separatorColor = separatorColor
        }
        
        UITableViewCell.appearance().apply {
            $0.backgroundColor = .clear
            $0.selectedBackgroundColor = secondaryBackgroundColor
        }
        
        UITextField.appearance().apply {
            $0.backgroundColor = .white
            $0.textColor = .black
        }
        
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .backgroundColor = tertiaryBackgroundColor
        
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self, UITableViewController.self])
            .backgroundColor = .clear
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .textColor = tertiaryLabelColor
    }
}

private extension Theme {
    
    func applyThemed() {
        applyThemedViews()
        applyThemedLabels()
        applyThemedButtons()
        applyThemedMisc()
    }
    
    private func applyThemedViews() {
        ThemedView.appearance().backgroundColor = backgroundColor
        
        ThemedSeparator.appearance().apply {
            $0.backgroundColor = separatorColor
            $0.alpha = 0.5
        }
    }
    
    private func applyThemedLabels() {
        ThemedLabel.appearance().textColor = labelColor
        ThemedHeadline.appearance().textColor = labelColor
        ThemedSubhead.appearance().textColor = secondaryLabelColor
        ThemedCaption.appearance().textColor = tertiaryLabelColor
        ThemedFootnote.appearance().textColor = quaternaryLabelColor
        ThemedTintLabel.appearance().textColor = tint
        ThemedDangerLabel.appearance().textColor = negativeColor
        ThemedSuccessLabel.appearance().textColor = positiveColor
        ThemedWarningLabel.appearance().textColor = secondaryTint
        ThemedLightLabel.appearance().textColor = tertiaryBackgroundColor
        ThemedDarkLabel.appearance().textColor = backgroundColor
    }
    
    private func applyThemedButtons() {
        ThemedButton.appearance().apply {
            $0.setTitleColor(tint, for: .normal)
            $0.borderColor = tint
            $0.borderWidth = 1
            $0.cornerRadius = buttonCornerRadius
        }
        
        ThemedLabelButton.appearance().apply {
            $0.setTitleColor(tint, for: .normal)
        }
        
        ThemedPrimaryButton.appearance().apply {
            $0.setTitleColor(backgroundColor, for: .normal)
            $0.setBackgroundImage(UIImage(from: tint), for: .normal)
            $0.titleLabelFont = .systemFont(ofSize: 15, weight: .bold)
            
            $0.setTitleColor(tint, for: .selected)
            $0.setBackgroundImage(UIImage(from: backgroundColor), for: .selected)
            
            $0.setTitleColor(backgroundColor, for: .disabled)
            $0.setBackgroundImage(UIImage(from: quaternaryLabelColor), for: .disabled)
            
            $0.cornerRadius = buttonCornerRadius
        }
        
        ThemedSecondaryButton.appearance().apply {
            $0.setTitleColor(secondaryLabelColor, for: .normal)
            $0.setBackgroundImage(UIImage(from: backgroundColor), for: .normal)
            $0.titleLabelFont = .systemFont(ofSize: 15, weight: .bold)
            $0.borderColor = secondaryLabelColor
            $0.borderWidth = 1
            $0.cornerRadius = buttonCornerRadius
        }
        
        ThemedImageButton.appearance().apply {
            $0.contentHorizontalAlignment = .fill
            $0.contentVerticalAlignment = .fill
            $0.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    private func applyThemedMisc() {
        ThemedSwitch.appearance().apply {
            $0.tintColor = tint
            $0.onTintColor = tint
        }
        
        ThemedSegmentedControl.appearance().tintColor = tint
        
        ThemedPageControl.appearance().apply {
            $0.pageIndicatorTintColor = separatorColor
            $0.currentPageIndicatorTintColor = tint
        }
    }
}

private extension Theme {
    
    func applyCustom() {
        ThemedView.appearance(whenContainedInInstancesOf: [LatestPostCollectionViewCell.self]).apply {
            $0.backgroundColor = secondaryBackgroundColor
            $0.borderColor = separatorColor
            $0.borderWidth = imageBorderWidthInCell
            $0.cornerRadius = 10
        }
        
        ThemedImageView.appearance(whenContainedInInstancesOf: [PopularPostCollectionViewCell.self]).apply {
            $0.borderColor = secondaryBackgroundColor
            $0.borderWidth = imageBorderWidthInCell
            $0.cornerRadius = 10
        }
        
        ThemedImageView.appearance(whenContainedInInstancesOf: [PickedPostCollectionViewCell.self]).apply {
            $0.borderColor = secondaryBackgroundColor
            $0.borderWidth = imageBorderWidthInCell
            $0.cornerRadius = 10
        }
        
        RoundedImageView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).apply {
            $0.borderColor = secondaryBackgroundColor
            $0.borderWidth = imageBorderWidthInCell
        }
    }
}

private extension Theme {
    
    func applyScenes() {
        HomeStyle.apply(self)
        ShowMoreStyles.apply(self)
    }
}

// MARK: - Helpers

private extension Theme {
    
    var imageBorderWidthInCell: CGFloat {
        isDarkStyle ? 0 : 1
    }
}
