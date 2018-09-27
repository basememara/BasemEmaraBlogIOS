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
    private let tint = UIColor(rgb: (49, 169, 234))
    private let secondaryTint = UIColor(rgb: (137, 167, 167))
    private let title: UIColor = .white
}

public extension DarkThemeStore {
    
    func apply(for application: UIApplication) {
        application.keyWindow?.tintColor = .tint
        
        UITabBar.appearance().barStyle = .black
        
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .tint
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.title
        ]
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [
                .foregroundColor: UIColor.title
            ]
        }
        
        UICollectionView.appearance().backgroundColor = .black
        UITableView.appearance().backgroundColor = .black
        UITableView.appearance().separatorColor = .lightGray
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionColor = UIColor(rgb: (38, 38, 40))
    }
}
