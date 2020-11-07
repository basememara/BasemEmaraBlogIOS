//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ShowMoreState: ObservableObject, Apply {
    @Published var moreMenu: [ShowMoreAPI.MenuSection]?
    @Published var socialMenu: [ShowMoreAPI.SocialItem]?
}
