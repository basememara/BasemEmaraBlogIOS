//
//  HomeModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import ZamzamUI

class HomeModel: ObservableObject, Model {
    @Published private(set) var profile: HomeAPI.Profile?
    @Published private(set) var homeMenu: [HomeAPI.MenuSection]?
    @Published private(set) var socialMenu: [HomeAPI.SocialItem]?
}
