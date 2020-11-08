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
    @Published var profile: HomeAPI.Profile?
    @Published var homeMenu: [HomeAPI.MenuSection]?
    @Published var socialMenu: [HomeAPI.SocialItem]?
}
