//
//  HomeStyle.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-10-26.
//

import SwiftyPress
import UIKit

enum HomeStyle {
    
    static func apply(_ theme: Theme) {
        UIImageView.appearance(whenContainedInInstancesOf: [UITableViewCell.self, UIViewController.self])
            .tintColor = theme.tint
        
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self, HomeViewController.self])
            .backgroundColor = .clear
    }
}
