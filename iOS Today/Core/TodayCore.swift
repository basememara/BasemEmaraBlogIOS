//
//  TodayCore.swift
//  BasemEmara iOS Today
//
//  Created by Basem Emara on 2019-10-26.
//

import Foundation
import SwiftyPress
import ZamzamCore

struct TodayCore: TodayCoreType {
    private let root: SwiftyPressCore
    
    init(root: SwiftyPressCore) {
        self.root = root
    }
}

extension TodayCore {
    
    func dependency(with viewController: TodayDisplayable?) -> TodayActionable {
        TodayAction(
            presenter: dependency(with: viewController),
            postProvider: root.dependency(),
            mediaProvider: root.dependency()
        )
    }
    
    func dependency(with viewController: TodayDisplayable?) -> TodayPresentable {
        TodayPresenter(viewController: viewController)
    }
    
    func dependency() -> DataProviderType {
        root.dependency()
    }
    
    func dependency() -> Theme {
        AppTheme()
    }
}
