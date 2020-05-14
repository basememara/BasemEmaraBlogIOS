//
//  MainModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

struct MainState: State {
    private(set) var tabMenu: [MainAPI.TabItem] = []
}

// MARK: - Reducer

extension MainState {
    
    enum MainAction: Action {
        case loadMenu([MainAPI.TabItem])
    }
    
    mutating func callAsFunction(_ action: MainAction) {
        switch action {
        case .loadMenu(let menu):
            tabMenu = menu
        }
    }
}
