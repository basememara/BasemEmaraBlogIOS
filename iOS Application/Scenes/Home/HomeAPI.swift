//
//  HomeAPI.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol HomeInteractorType: InteractorType {
    func fetchProfile()
    func fetchMenu()
    func fetchSocial()
    func select(menu: HomeAPI.MenuItem)
    func select(social: Social)
}

protocol HomePresenterType: PresenterType {
    func displayProfile(avatar: String, name: String, caption: String)
    func display(menu: [HomeAPI.MenuSection])
    func display(social: [HomeAPI.SocialItem])
    func display(menu: HomeAPI.MenuItem)
    func display(social: Social)
}

// MARK: - Namespace

enum HomeAPI {
    
    enum Menu: String {
        case about
        case portfolio
        case seriesScalableApp
        case seriesSwiftUtilities
        case coursesArchitecture
        case coursesFramework
        case consultingDevelopment
        case consultingMentorship
    }
    
    struct MenuItem {
        let type: Menu
        let title: String
    }
    
    struct MenuSection {
        let title: String?
        let items: [MenuItem]
    }
    
    struct SocialItem {
        let type: Social
        let title: String
    }
}
