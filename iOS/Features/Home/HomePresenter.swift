//
//  HomeRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamUI

struct HomePresenter: HomePresentable {
    private let store: StoreReducer<HomeReducer>
    
    init(_ store: @escaping StoreReducer<HomeReducer>) {
        self.store = store
    }
}

extension HomePresenter {
    
    func display(profile: HomeAPI.Profile) {
        store(.loadProfile(profile))
    }
    
    func display(menu: [HomeAPI.MenuSection]) {
        store(.loadMenu(menu))
    }
    
    func display(social: [HomeAPI.SocialItem]) {
        store(.loadSocial(social))
    }
}
