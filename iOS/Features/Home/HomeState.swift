//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import ZamzamCore

class HomeState: ObservableObject, Apply {
    @Published var profile: HomeAPI.Profile?
    @Published var homeMenu: [HomeAPI.MenuSection]?
    @Published var socialMenu: [HomeAPI.SocialItem]?
}
