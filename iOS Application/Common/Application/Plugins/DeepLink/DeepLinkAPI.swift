//
//  DeepLinkAPI.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-28.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore
import ZamzamUI

/// Container of dependencies needed to execute this feature.
protocol DeepLinkCoreType {
    func router() -> DeepLinkRouterable
    func log() -> LogRepository
}

protocol DeepLinkRouterable {
    
    @discardableResult
    func navigate(from url: URL) -> Bool
}
