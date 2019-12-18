//
//  MainReducer.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//
import Foundation

struct MainReducer: MainReducerType {
    
    func reduce(_ state: AppState, _ action: MainAction) -> AppState {
        switch action {
        case .loadMenu(let menu, let layout):
            state.main = MainModel(menu: menu, layout: layout)
        }
        
        return state
    }
}
