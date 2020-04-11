//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//

import SwiftyPress

struct HomeState: StateType {
    private(set) var profileAvatar: String = ""
    private(set) var profileName: String = ""
    private(set) var profileCaption: String = ""
    private(set) var homeMenu: [HomeAPI.MenuSection] = []
    private(set) var socialMenu: [HomeAPI.SocialItem] = []
}

// MARK: - Reducer

extension HomeState {
    
    enum Action: ActionType {
        case loadProfile(avatar: String, name: String, caption: String)
        case loadMenu([HomeAPI.MenuSection])
        case loadSocial([HomeAPI.SocialItem])
    }
    
    mutating func receive(_ action: Action) {
        switch action {
        case .loadProfile(let avatar, let name, let caption):
            profileAvatar = avatar
            profileName = name
            profileCaption = caption
        case .loadMenu(let sections):
            homeMenu = sections
        case .loadSocial(let social):
            socialMenu = social
        }
    }
}
