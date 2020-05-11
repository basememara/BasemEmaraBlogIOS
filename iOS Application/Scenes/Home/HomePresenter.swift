//
//  HomeRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

struct HomePresenter<Store: StoreType>: HomePresenterType where Store.State == HomeState {
    private let store: Store
    
    init(store: Store) {
        self.store = store
    }
}

extension HomePresenter {
    
    func display(profile: HomeAPI.Profile) {
        store.send(.loadProfile(profile))
    }
    
    func display(menu: [HomeAPI.MenuSection]) {
        store.send(.loadMenu(menu))
    }
    
    func display(social: [HomeAPI.SocialItem]) {
        store.send(.loadSocial(social))
    }
}
