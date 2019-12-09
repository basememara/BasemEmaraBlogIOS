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
    private let core: SwiftyPressCore
    
    init(core: SwiftyPressCore) {
        self.core = core
    }
}

extension TodayCore {
    
    func dependency(with viewController: TodayDisplayable?) -> TodayActionable {
        TodayAction(
            presenter: dependency(with: viewController),
            postProvider: core.dependency(),
            mediaProvider: core.dependency()
        )
    }
    
    func dependency(with viewController: TodayDisplayable?) -> TodayPresentable {
        TodayPresenter(viewController: viewController)
    }
    
    func dependency() -> DataProviderType {
        core.dependency()
    }
    
    func dependency() -> Theme {
        AppTheme()
    }
}
