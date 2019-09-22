//
//  ListTermsModule.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress

struct ListTermsModule: ListTermsModuleType {
    
    func resolve(with viewController: ListTermsDisplayable?) -> ListTermsActionable {
        ListTermsAction(
            presenter: resolve(with: viewController),
            taxonomyWorker: resolve()
        )
    }
    
    func resolve(with viewController: ListTermsDisplayable?) -> ListTermsPresentable {
        ListTermsPresenter(viewController: viewController)
    }
    
    func resolve(with viewController: UIViewController?) -> ListTermsRoutable {
        ListTermsRouter(
            viewController: viewController,
            scenes: resolve()
        )
    }
}

extension ListTermsModule: Module {
    
    func register() {
        make { self as ListTermsModuleType }
    }
}
