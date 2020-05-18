//
//  HomeRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

struct HomePresenter: HomePresentable {
    private let dispatch: Dispatcher<HomeAction>
    
    init(dispatch: @escaping Dispatcher<HomeAction>) {
        self.dispatch = dispatch
    }
}

extension HomePresenter {
    
    func display(profile: HomeAPI.Profile) {
        dispatch(.loadProfile(profile))
    }
    
    func display(menu: [HomeAPI.MenuSection]) {
        dispatch(.loadMenu(menu))
    }
    
    func display(social: [HomeAPI.SocialItem]) {
        dispatch(.loadSocial(social))
    }
}
