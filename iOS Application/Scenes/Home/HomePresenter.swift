//
//  HomeRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct HomePresenter: HomePresentable {
    private let state: Reducer<HomeAction>
    
    init(state: @escaping Reducer<HomeAction>) {
        self.state = state
    }
}

extension HomePresenter {
    
    func display(profile: HomeAPI.Profile) {
        state(.loadProfile(profile))
    }
    
    func display(menu: [HomeAPI.MenuSection]) {
        state(.loadMenu(menu))
    }
    
    func display(social: [HomeAPI.SocialItem]) {
        state(.loadSocial(social))
    }
}
