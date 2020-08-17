//
//  MainPresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import ZamzamUI

struct MainPresenter: MainPresentable {
    private let state: Reduce<MainReducer>
    
    init(state: @escaping Reduce<MainReducer>) {
        self.state = state
    }
}

extension MainPresenter {
    
    func display(menu: [MainAPI.TabItem]) {
        state(.loadMenu(menu))
    }
}
