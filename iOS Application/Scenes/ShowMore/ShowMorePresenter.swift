//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

struct ShowMorePresenter: ShowMorePresenterType {
    private let send: SendAction<ShowMoreState>
    
    init(send: @escaping SendAction<ShowMoreState>) {
        self.send = send
    }
}

extension ShowMorePresenter {
    
    func display(menu: [ShowMoreAPI.MenuSection]) {
        send(.loadMenu(menu))
    }
    
    func display(social: [ShowMoreAPI.SocialItem]) {
        send(.loadSocial(social))
    }
}
