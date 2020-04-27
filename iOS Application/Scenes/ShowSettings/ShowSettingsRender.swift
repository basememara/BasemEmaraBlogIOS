//
//  ShowMoreRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation.NSURL
import UIKit.UIApplication

struct ShowSettingsRender: ShowSettingsRenderType {
    private let application: UIApplication
    
    init(application: UIApplication) {
        self.application = application
    }
}

extension ShowSettingsRender {
    
    func openSettings() {
        guard let settings = URL(string: UIApplication.openSettingsURLString) else { return }
        application.open(settings)
    }
}
