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

struct DataPlugin: ApplicationPlugin {
    private let dataRepository: DataRepositoryType
    
    init(dataRepository: DataRepositoryType) {
        self.dataRepository = dataRepository
    }
}

extension DataPlugin {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dataRepository.configure()
        return true
    }
}
