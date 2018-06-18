//
//  ThemeApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

final class ThemeApplicationService: ApplicationService {
    
}

extension ThemeApplicationService {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
        UITableViewCell.appearance().backgroundColor = .clear
        
        return true
    }
}
