//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ShowMoreState: StateType {
    private(set) var moreMenu: [ShowMoreAPI.MenuSection] = []
    private(set) var socialMenu: [ShowMoreAPI.SocialItem] = []
}

// MARK: - Reducer

extension ShowMoreState {
    
    enum Action: ActionType {
        case loadMenu([ShowMoreAPI.MenuSection])
        case loadSocial([ShowMoreAPI.SocialItem])
    }
    
    mutating func receive(_ action: Action) {
        switch action {
        case .loadMenu(let sections):
            moreMenu = sections
        case .loadSocial(let social):
            socialMenu = social
        }
    }
}
