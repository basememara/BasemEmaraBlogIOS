//
//  MainPresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

struct MainPresenter: MainPresentable {
    private let dispatch: Dispatcher<MainAction>
    
    init(dispatch: @escaping Dispatcher<MainAction>) {
        self.dispatch = dispatch
    }
}

extension MainPresenter {
    
    func display(menu: [MainAPI.TabItem]) {
        dispatch(.loadMenu(menu))
    }
}
