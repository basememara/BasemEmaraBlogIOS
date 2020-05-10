//
//  TodayCore.swift
//  BasemEmara iOS Today
//
//  Created by Basem Emara on 2019-10-26.
//

import Foundation
import SwiftyPress
import UIKit.UIViewController
import ZamzamCore

struct TodayCore: TodayCoreType {
    private let root: SwiftyPressCore
    
    init(root: SwiftyPressCore) {
        self.root = root
    }
}

extension TodayCore {
    
    func action(with viewController: (TodayDisplayable & UIViewController)?) -> TodayActionable {
        TodayAction(
            presenter: presenter(with: viewController),
            postRepository: root.postRepository(),
            mediaRepository: root.mediaRepository()
        )
    }
    
    func presenter(with viewController: (TodayDisplayable & UIViewController)?) -> TodayPresentable {
        TodayPresenter(viewController: viewController)
    }
    
    func dataRepository() -> DataRepository {
        root.dataRepository()
    }
    
    func theme() -> Theme {
        AppTheme()
    }
}
