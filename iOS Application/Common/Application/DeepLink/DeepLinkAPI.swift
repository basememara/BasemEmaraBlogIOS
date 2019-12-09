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
    func dependency() -> DeepLinkRenderable
    func dependency() -> LogProviderType
}

protocol DeepLinkRenderable: AppRoutable {
    
    @discardableResult
    func navigate(from url: URL) -> Bool
}
