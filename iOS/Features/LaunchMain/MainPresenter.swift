//
//  MainPresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import ZamzamUI

struct MainPresenter: MainPresentable {
    private let store: StoreReducer<MainReducer>
    
    init(_ store: @escaping StoreReducer<MainReducer>) {
        self.store = store
    }
}

extension MainPresenter {
    
    func display(menu: [MainAPI.TabItem]) {
        store(.loadMenu(menu))
    }
}
