//
//  ListTermsCore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ListTermsCore: ListTermsCoreType {
    private let core: SwiftyPressCore
    private let render: SceneRenderType
    
    init(core: SwiftyPressCore, render: SceneRenderType) {
        self.core = core
        self.render = render
    }
    
    func dependency(with viewController: ListTermsDisplayable?) -> ListTermsActionable {
        ListTermsAction(
            presenter: dependency(with: viewController),
            taxonomyProvider: core.dependency()
        )
    }
    
    func dependency(with viewController: ListTermsDisplayable?) -> ListTermsPresentable {
        ListTermsPresenter(viewController: viewController)
    }
    
    func dependency(with viewController: UIViewController?) -> ListTermsRenderable {
        ListTermsRender(
            render: render,
            viewController: viewController
        )
    }
}
