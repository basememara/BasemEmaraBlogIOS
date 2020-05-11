//
//  MainPresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

struct MainPresenter<Store: StoreType>: MainPresenterType where Store.State == MainState {
    private let store: Store
    
    init(store: Store) {
        self.store = store
    }
}

extension MainPresenter {
    
    func display(menu: [MainAPI.TabItem]) {
        store.send(.loadMenu(menu))
    }
}
