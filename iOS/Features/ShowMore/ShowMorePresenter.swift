//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamUI

struct ShowMorePresenter: ShowMorePresentable {
    private let store: StoreReducer<ShowMoreReducer>
    
    init(_ store: @escaping StoreReducer<ShowMoreReducer>) {
        self.store = store
    }
}

extension ShowMorePresenter {
    
    func display(menu: [ShowMoreAPI.MenuSection]) {
        store(.loadMenu(menu))
    }
    
    func display(social: [ShowMoreAPI.SocialItem]) {
        store(.loadSocial(social))
    }
}
