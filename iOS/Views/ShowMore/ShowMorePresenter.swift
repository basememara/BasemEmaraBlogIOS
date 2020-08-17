//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamUI

struct ShowMorePresenter: ShowMorePresentable {
    private let state: StateReducer<ShowMoreReducer>
    
    init(state: @escaping StateReducer<ShowMoreReducer>) {
        self.state = state
    }
}

extension ShowMorePresenter {
    
    func display(menu: [ShowMoreAPI.MenuSection]) {
        state(.loadMenu(menu))
    }
    
    func display(social: [ShowMoreAPI.SocialItem]) {
        state(.loadSocial(social))
    }
}
