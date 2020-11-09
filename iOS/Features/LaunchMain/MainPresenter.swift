//
//  MainPresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import ZamzamUI

struct MainPresenter: MainPresentable {
    var model: MainModel
}

extension MainPresenter {
    
    func display(menu: [MainAPI.TabItem]) {
        model(\.tabMenu, menu)
    }
}
