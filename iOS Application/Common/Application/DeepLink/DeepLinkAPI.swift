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

// Namespace use
enum DeepLinkAPI {}

/// Container of dependencies needed to execute this feature.
protocol DeepLinkModuleType {
    func component() -> DeepLinkRoutable
    func component() -> LogWorkerType
}

protocol DeepLinkRoutable: AppRoutable {
    func showPost(for id: Int)
    func showFavorites()
    func sendFeedback()
    func navigate(from url: URL) -> Bool
}
