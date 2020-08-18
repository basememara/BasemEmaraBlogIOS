//
//  HomeAPI.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamUI

protocol HomeActionable: Action {
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
    
    struct MenuItem: Equatable {
        let type: Menu
        let title: String
        let icon: String
    }
    
    struct MenuSection: Equatable {
        let title: String?
        let items: [MenuItem]
    }
    
    struct Profile: Equatable {
        let avatar: String
        let name: String
        let caption: String
    }
    
    struct SocialItem: Equatable {
        let type: Social
        let title: String
    }
}
