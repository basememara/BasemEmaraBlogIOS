//
//  ShowMoreModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ShowMoreModel: ObservableObject, Model {
    @Published private(set) var moreMenu: [ShowMoreAPI.MenuSection]?
    @Published private(set) var socialMenu: [ShowMoreAPI.SocialItem]?
}
