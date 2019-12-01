//
//  TodayModule.swift
//  BasemEmara iOS Today
//
//  Created by Basem Emara on 2019-10-26.
//

import Foundation
import SwiftyPress
import ZamzamCore

struct TodayModule: TodayModuleType {
    @Inject private var appModule: SwiftyPressModule
    
    func component(with viewController: TodayDisplayable?) -> TodayActionable {
        TodayAction(
            presenter: component(with: viewController),
            postProvider: appModule.component(),
            mediaProvider: appModule.component()
        )
    }
    
    func component(with viewController: TodayDisplayable?) -> TodayPresentable {
        TodayPresenter(viewController: viewController)
    }
    
    func component() -> DataProviderType {
        appModule.component()
    }
    
    func component() -> Theme {
        AppTheme()
    }
}
