//
//  Theme.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-09-22.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import UIKit
import ZamzamUI
import SwiftyPress

struct AppTheme: Theme {
    let tint = UIColor(named: "tint") ?? .init(rgb: (49, 169, 234))
    let secondaryTint = UIColor(named: "secondaryTint") ?? .init(rgb: (137, 167, 167))
    
    let backgroundColor = UIColor(named: "backgroundColor") ?? .black
    let secondaryBackgroundColor = UIColor(named: "secondaryBackgroundColor") ?? .init(rgb: (28, 28, 30))
    let tertiaryBackgroundColor = UIColor(named: "tertiaryBackgroundColor") ?? .init(rgb: (44, 44, 46))
    let quaternaryBackgroundColor = UIColor(named: "quaternaryBackgroundColor") ?? .init(rgb: (58, 58, 60))
    
    let separatorColor = UIColor(named: "separatorColor") ?? .darkGray
    let opaqueColor = UIColor(named: "opaqueColor") ?? .lightGray
    
    let labelColor = UIColor(named: "labelColor") ?? .white
    let secondaryLabelColor = UIColor(named: "secondaryLabelColor") ?? .init(rgb: (242, 242, 247))
    let tertiaryLabelColor = UIColor(named: "tertiaryLabelColor") ?? .init(rgb: (229, 229, 234))
    let quaternaryLabelColor = UIColor(named: "quaternaryLabelColor") ?? .init(rgb: (209, 209, 214))
    let placeholderLabelColor = UIColor(named: "placeholderLabelColor") ?? .darkGray
    
    let buttonCornerRadius: CGFloat = 3
    
    let positiveColor = UIColor(named: "positiveColor") ?? .green
    let negativeColor = UIColor(named: "negativeColor") ?? .red
    
    let isDarkStyle: Bool = {
        guard #available(iOS 13.0, *) else { return true }
        return UITraitCollection.current.userInterfaceStyle == .dark
    }()
}

extension Theme {
    
    func apply(for application: UIApplication?) {
        application?.keyWindow?.tintColor = tint
        
        applyPlatform()
        applyThemed()
        applyCustom()
        applyScenes()
    }
}

private extension Theme {
    
    func applyPlatform() {
        UITabBar.appearance().with {
            $0.tintColor = tint
        }
        
        UINavigationBar.appearance().with {
            $0.tintColor = tint
            $0.titleTextAttributes = [
                .foregroundColor: labelColor
            ]
            $0.largeTitleTextAttributes = [
                .foregroundColor: labelColor
            ]
        }
        
        UIToolbar.appearance().with {
            $0.tintColor = tint
        }
        
        UICollectionView.appearance().backgroundColor = backgroundColor
        
        UITableView.appearance().with {
            $0.backgroundColor = backgroundColor
            $0.separatorColor = separatorColor
        }
        
        UITableViewCell.appearance().with {
            $0.backgroundColor = .clear
            $0.selectionColor = secondaryBackgroundColor
        }
        
        UITextField.appearance().with {
            $0.backgroundColor = .white
            $0.textColor = .black
        }

        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .backgroundColor = tertiaryBackgroundColor
        
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self, UITableViewController.self])
            .backgroundColor = .clear
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .textColor = tertiaryLabelColor
        
        UIImageView.appearance(whenContainedInInstancesOf: [UIButton.self, UITableViewCell.self, UIViewController.self])
            .tintColor = tint
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
        
        ThemedSeparator.appearance().with {
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
        ThemedButton.appearance().with {
            $0.setTitleColor(tint, for: .normal)
            $0.borderColor = tint
            $0.borderWidth = 1
            $0.cornerRadius = buttonCornerRadius
        }
        
        ThemedLabelButton.appearance().with {
            $0.setTitleColor(tint, for: .normal)
        }
        
        ThemedPrimaryButton.appearance().with {
            $0.setTitleColor(backgroundColor, for: .normal)
            $0.setBackgroundImage(UIImage(from: tint), for: .normal)
            $0.titleFont = .systemFont(ofSize: 15, weight: .bold)
            
            $0.setTitleColor(tint, for: .selected)
            $0.setBackgroundImage(UIImage(from: backgroundColor), for: .selected)
            
            $0.setTitleColor(backgroundColor, for: .disabled)
            $0.setBackgroundImage(UIImage(from: quaternaryLabelColor), for: .disabled)
            
            $0.cornerRadius = buttonCornerRadius
        }
        
        ThemedSecondaryButton.appearance().with {
            $0.setTitleColor(secondaryLabelColor, for: .normal)
            $0.setBackgroundImage(UIImage(from: backgroundColor), for: .normal)
            $0.titleFont = .systemFont(ofSize: 15, weight: .bold)
            $0.borderColor = secondaryLabelColor
            $0.borderWidth = 1
            $0.cornerRadius = buttonCornerRadius
        }
        
        ThemedImageButton.appearance().with {
            $0.contentHorizontalAlignment = .fill
            $0.contentVerticalAlignment = .fill
            $0.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    private func applyThemedMisc() {
        ThemedSwitch.appearance().with {
            $0.tintColor = tint
            $0.onTintColor = tint
        }
        
        ThemedSegmentedControl.appearance().tintColor = tint
        
        ThemedPageControl.appearance().with {
            $0.pageIndicatorTintColor = separatorColor
            $0.currentPageIndicatorTintColor = tint
        }
    }
}
    
private extension Theme {
        
    func applyCustom() {
        ThemedView.appearance(whenContainedInInstancesOf: [LatestPostCollectionViewCell.self]).with {
            $0.backgroundColor = secondaryBackgroundColor
            $0.borderColor = separatorColor
            $0.borderWidth = imageBorderWidthInCell
            $0.cornerRadius = 10
        }
        
        ThemedImageView.appearance(whenContainedInInstancesOf: [PopularPostCollectionViewCell.self]).with {
            $0.borderColor = secondaryBackgroundColor
            $0.borderWidth = imageBorderWidthInCell
            $0.cornerRadius = 10
        }
        
        ThemedImageView.appearance(whenContainedInInstancesOf: [PickedPostCollectionViewCell.self]).with {
            $0.borderColor = secondaryBackgroundColor
            $0.borderWidth = imageBorderWidthInCell
            $0.cornerRadius = 10
        }
        
        RoundedImageView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).with {
            $0.borderColor = secondaryBackgroundColor
            $0.borderWidth = imageBorderWidthInCell
        }
    }
}

private extension Theme {
    
    func applyScenes() {
        ShowBlogStyles.apply(self)
    }
}

// MARK: - Helpers

private extension Theme {
    
    var imageBorderWidthInCell: CGFloat {
        isDarkStyle ? 0 : 1
    }
}
