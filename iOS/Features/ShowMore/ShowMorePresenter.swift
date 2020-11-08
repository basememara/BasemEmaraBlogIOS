//
//  ShowMorePresenter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamUI

struct ShowMorePresenter: ShowMorePresentable {
    var model: ShowMoreModel
}

extension ShowMorePresenter {
    
    func display(menu: [ShowMoreAPI.MenuSection]) {
        model.moreMenu = menu
    }
    
    func display(social: [ShowMoreAPI.SocialItem]) {
        model.socialMenu = social
    }
}
