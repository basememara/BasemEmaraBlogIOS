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

protocol ShowMoreModuleType {
    func component(with viewController: UIViewController?) -> ShowMoreRoutable
    func component() -> ConstantsType
}

protocol ShowMoreRoutable: AppRoutable {
    func showSubscribe()
    func sendFeedback(subject: String)
    func showWorkWithMe()
    func showRateApp()
    func showSettings()
    func showDevelopedBy()
    func showSocial(for type: Social)
}
