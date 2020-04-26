//
//  ShowMoreInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit.UIView

protocol ShowMoreInteractorType: InteractorType {
    func fetchMenu()
    func fetchSocial()
}

protocol ShowMorePresenterType: PresenterType {
    func display(menu: [ShowMoreAPI.MenuSection])
    func display(social: [ShowMoreAPI.SocialItem])
}

protocol ShowMoreRenderType: RenderType {
    func select(menu: ShowMoreAPI.MenuItem, from view: UIView)
    func select(social: Social)
    func sendFeedback(subject: String)
}

// MARK: - Namespace

enum ShowMoreAPI {
    
    enum Menu: String {
        case subscribe
        case feedback
        case work
        case rate
        case share
        case settings
        case social
        case developedBy
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
    
    struct SocialItem {
        let type: Social
        let title: String
    }
}
