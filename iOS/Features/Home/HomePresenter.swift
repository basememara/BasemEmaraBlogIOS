//
//  HomeRender.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-24.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamUI

struct HomePresenter: HomePresentable {
    var model: HomeModel
}

extension HomePresenter {
    
    func display(profile: HomeAPI.Profile) {
        model.profile = profile
    }
    
    func display(menu: [HomeAPI.MenuSection]) {
        model.homeMenu = menu
    }
    
    func display(social: [HomeAPI.SocialItem]) {
        model.socialMenu = social
    }
}
