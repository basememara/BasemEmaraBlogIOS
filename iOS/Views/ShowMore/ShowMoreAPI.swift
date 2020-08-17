//
//  ShowMoreInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit.UIView
import ZamzamUI

protocol ShowMoreActionable: Action {
    func fetchMenu()
    func fetchSocial()
}

protocol ShowMorePresentable: Presenter {
    func display(menu: [ShowMoreAPI.MenuSection])
    func display(social: [ShowMoreAPI.SocialItem])
}

protocol ShowMoreRenderable: Render {
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
    
    struct MenuItem: Equatable {
        let type: Menu
        let title: String
        let icon: String
    }
    
    struct MenuSection: Equatable {
        let title: String?
        let items: [MenuItem]
    }
    
    struct SocialItem: Equatable {
        let type: Social
        let title: String
    }
}
