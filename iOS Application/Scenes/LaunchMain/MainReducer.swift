//
//  MainReducer.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//

struct MainReducer: ReducerType {
    let presenter: MainPresenterType
}

extension MainReducer {
    
    func callAsFunction(_ state: inout MainState, _ action: MainAction) {
        switch action {
        case .fetchMenu(let idiom):
            state.tabMenu = presenter.fetchMenu(for: idiom)
        }
    }
}
