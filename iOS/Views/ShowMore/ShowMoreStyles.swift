//
//  ShowMoreStyles.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-10-26.
//

import SwiftyPress
import UIKit

enum ShowMoreStyles {
    
    static func apply(_ theme: Theme) {
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self, ShowMoreViewController.self])
            .backgroundColor = .clear
    }
}
