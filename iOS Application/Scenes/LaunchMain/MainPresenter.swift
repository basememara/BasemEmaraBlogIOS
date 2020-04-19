//
//  MainPresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

struct MainPresenter: MainPresenterType {
    private let send: SendAction<MainState>
    
    init(send: @escaping SendAction<MainState>) {
        self.send = send
    }
}

extension MainPresenter {
    
    func display(menu: [MainAPI.TabItem]) {
        send(.loadMenu(menu))
    }
}
