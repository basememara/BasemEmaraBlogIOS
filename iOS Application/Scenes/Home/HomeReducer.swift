//
//  HomeReducer.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-29.
//

import SwiftyPress

struct HomeReducer: ReducerType {
    private let presenter: HomePresenterType
    
    init(presenter: HomePresenterType) {
        self.presenter = presenter
    }
}

extension HomeReducer {
    
    func callAsFunction(_ state: inout HomeState, _ action: HomeAction) {
        switch action {
        case .loadProfile(let avatar, let name, let caption):
            state.profileAvatar = avatar
            state.profileName = name
            state.profileCaption = caption
        case .loadMenu(let sections):
            state.homeMenu = sections
        case .loadSocial(let social):
            state.socialMenu = social
        case .selectMenu(let item):
            presenter.select(menu: item)
        case .selectSocial(let item):
            presenter.select(social: item)
        }
    }
}
