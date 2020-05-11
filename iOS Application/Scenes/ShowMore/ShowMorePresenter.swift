//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

struct ShowMorePresenter<Store: StoreType>: ShowMorePresenterType where Store.State == ShowMoreState {
    private let store: Store
    
    init(store: Store) {
        self.store = store
    }
}

extension ShowMorePresenter {
    
    func display(menu: [ShowMoreAPI.MenuSection]) {
        store.send(.loadMenu(menu))
    }
    
    func display(social: [ShowMoreAPI.SocialItem]) {
        store.send(.loadSocial(social))
    }
}
