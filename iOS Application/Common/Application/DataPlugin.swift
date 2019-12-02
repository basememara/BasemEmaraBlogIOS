//
//  DataApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-19.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

final class DataPlugin: ApplicationPlugin {
    @Inject private var module: SwiftyPressCore
    private lazy var dataProvider: DataProviderType = module.dependency()
}

extension DataPlugin {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dataProvider.configure()
        return true
    }
}
