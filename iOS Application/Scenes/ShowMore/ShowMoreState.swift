//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ShowMoreState: State {
    private(set) var moreMenu: [ShowMoreAPI.MenuSection] = []
    private(set) var socialMenu: [ShowMoreAPI.SocialItem] = []
}

// MARK: - Reducer

extension ShowMoreState {
    
    enum ShowMoreAction: Action {
        case loadMenu([ShowMoreAPI.MenuSection])
        case loadSocial([ShowMoreAPI.SocialItem])
    }
    
    mutating func callAsFunction(_ action: ShowMoreAction) {
        switch action {
        case .loadMenu(let sections):
            moreMenu = sections
        case .loadSocial(let social):
            socialMenu = social
        }
    }
}
