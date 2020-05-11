//
//  HomeAPI.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol HomeInteractable: Interactor {
    func fetchProfile()
    func fetchMenu()
    func fetchSocial()
}

protocol HomePresentable: Presenter {
    func display(profile: HomeAPI.Profile)
    func display(menu: [HomeAPI.MenuSection])
    func display(social: [HomeAPI.SocialItem])
}

protocol HomeRenderable: Render {
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
        let icon: String
    }
    
    struct MenuSection {
        let title: String?
        let items: [MenuItem]
    }
    
    struct Profile {
        let avatar: String
        let name: String
        let caption: String
    }
    
    struct SocialItem {
        let type: Social
        let title: String
    }
}
