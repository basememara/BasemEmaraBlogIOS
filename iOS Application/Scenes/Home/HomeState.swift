//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct HomeState: State {
    private(set) var profile: HomeAPI.Profile?
    private(set) var homeMenu: [HomeAPI.MenuSection] = []
    private(set) var socialMenu: [HomeAPI.SocialItem] = []
}

// MARK: - Reducer

extension HomeState {
    
    enum HomeAction: Action {
        case loadProfile(HomeAPI.Profile)
        case loadMenu([HomeAPI.MenuSection])
        case loadSocial([HomeAPI.SocialItem])
    }
    
    mutating func callAsFunction(_ action: HomeAction) {
        switch action {
        case .loadProfile(let profile):
            self.profile = profile
        case .loadMenu(let sections):
            homeMenu = sections
        case .loadSocial(let social):
            socialMenu = social
        }
    }
}
