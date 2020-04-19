//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct HomeState: StateType {
    private(set) var profile: HomeAPI.Profile?
    private(set) var homeMenu: [HomeAPI.MenuSection] = []
    private(set) var socialMenu: [HomeAPI.SocialItem] = []
}

// MARK: - Reducer

extension HomeState {
    
    enum Action: ActionType {
        case loadProfile(HomeAPI.Profile)
        case loadMenu([HomeAPI.MenuSection])
        case loadSocial([HomeAPI.SocialItem])
    }
    
    mutating func receive(_ action: Action) {
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
