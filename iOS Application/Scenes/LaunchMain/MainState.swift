//
//  MainModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//

struct MainState: StateType {
    private(set) var tabMenu: [MainAPI.TabItem] = []
}

// MARK: - Mutations

extension MainState {
    
    enum Input: InputType {
        case loadMenu([MainAPI.TabItem])
    }
    
    mutating func receive(_ input: Input) {
        switch input {
        case .loadMenu(let menu):
            tabMenu = menu
        }
    }
}
