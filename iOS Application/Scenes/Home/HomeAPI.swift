//
//  HomeAPI.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//

import SwiftyPress

protocol HomeActionType: ActionType {
    func fetchProfile()
    func fetchMenu()
    func fetchSocial()
    func select(menu: HomeAPI.MenuItem)
    func select(social: Social)
}

protocol HomePresenterType: PresenterType {
    func loadProfile(avatar: String, name: String, caption: String)
    func load(menu: [HomeAPI.MenuSection])
    func load(social: [HomeAPI.SocialItem])
    func select(menu: HomeAPI.MenuItem)
    func select(social: Social)
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
