//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

struct ShowMorePresenter<Store: StoreRepresentable>: ShowMorePresentable where Store.StateType == ShowMoreState {
    private let store: Store
    
    init(store: Store) {
        self.store = store
    }
}

extension ShowMorePresenter {
    
    func display(menu: [ShowMoreAPI.MenuSection]) {
        store.action(.loadMenu(menu))
    }
    
    func display(social: [ShowMoreAPI.SocialItem]) {
        store.action(.loadSocial(social))
    }
}
