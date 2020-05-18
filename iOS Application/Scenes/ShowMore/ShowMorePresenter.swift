//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

struct ShowMorePresenter: ShowMorePresentable {
    private let dispatch: Dispatcher<ShowMoreAction>
    
    init(dispatch: @escaping Dispatcher<ShowMoreAction>) {
        self.dispatch = dispatch
    }
}

extension ShowMorePresenter {
    
    func display(menu: [ShowMoreAPI.MenuSection]) {
        dispatch(.loadMenu(menu))
    }
    
    func display(social: [ShowMoreAPI.SocialItem]) {
        dispatch(.loadSocial(social))
    }
}
