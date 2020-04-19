//
//  HomeRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

struct HomePresenter: HomePresenterType {
    private let send: SendAction<HomeState>
    
    init(send: @escaping SendAction<HomeState>) {
        self.send = send
    }
}

extension HomePresenter {
    
    func display(profile: HomeAPI.Profile) {
        send(.loadProfile(profile))
    }
    
    func display(menu: [HomeAPI.MenuSection]) {
        send(.loadMenu(menu))
    }
    
    func display(social: [HomeAPI.SocialItem]) {
        send(.loadSocial(social))
    }
}
