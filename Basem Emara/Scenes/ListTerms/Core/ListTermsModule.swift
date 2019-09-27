//
//  ListTermsModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ListTermsModule: ListTermsModuleType {
    @Inject private var appModule: SwiftyPressModule
    @Inject private var sceneModule: SceneModuleType
    
    func component(with viewController: ListTermsDisplayable?) -> ListTermsActionable {
        ListTermsAction(
            presenter: component(with: viewController),
            taxonomyWorker: appModule.component()
        )
    }
    
    func component(with viewController: ListTermsDisplayable?) -> ListTermsPresentable {
        ListTermsPresenter(viewController: viewController)
    }
    
    func component(with viewController: UIViewController?) -> ListTermsRoutable {
        ListTermsRouter(
            viewController: viewController,
            scenes: sceneModule
        )
    }
}
