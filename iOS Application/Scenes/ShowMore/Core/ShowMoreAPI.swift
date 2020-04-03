//
//  ShowMoreInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI

protocol ShowMoreCoreType {
    func router(with viewController: UIViewController?) -> ShowMoreRouterable
    func constants() -> ConstantsType
}

protocol ShowMoreRouterable {
    func showSubscribe()
    func sendFeedback(subject: String)
    func showWorkWithMe()
    func showRateApp()
    func showSettings()
    func showDevelopedBy()
    func show(social: Social)
    
    func share(
        appURL: String,
        message: String,
        popoverFrom view: UIView
    )
}
