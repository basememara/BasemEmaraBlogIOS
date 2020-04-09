//
//  MainModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//

struct MainState: StateType {
    private(set) var tabMenu: [MainAPI.TabItem] = []
}

// MARK: - Reducer

extension MainState {
    
    enum Action: ActionType {
        case loadMenu([MainAPI.TabItem])
    }
    
    mutating func receive(_ action: Action) {
        switch action {
        case .loadMenu(let menu):
            tabMenu = menu
        }
    }
}
