//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

class HomeState: StateRepresentable {
    
    private(set) var profile: HomeAPI.Profile? {
        willSet {
            guard newValue != profile, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != profile else { return }
            notificationPost(keyPath: \HomeState.profile)
        }
    }
    
    private(set) var homeMenu: [HomeAPI.MenuSection] = [] {
        willSet {
            guard newValue != homeMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != homeMenu else { return }
            notificationPost(keyPath: \HomeState.homeMenu)
        }
    }
    
    private(set) var socialMenu: [HomeAPI.SocialItem] = [] {
        willSet {
            guard newValue != socialMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != socialMenu else { return }
            notificationPost(keyPath: \HomeState.socialMenu)
        }
    }
}

// MARK: - Action

enum HomeAction: Action {
    case loadProfile(HomeAPI.Profile)
    case loadMenu([HomeAPI.MenuSection])
    case loadSocial([HomeAPI.SocialItem])
}

// MARK: - Reducer

extension HomeState {
    
    func callAsFunction(_ action: HomeAction) {
        switch action {
        case .loadProfile(let item):
            profile = item
        case .loadMenu(let items):
            homeMenu = items
        case .loadSocial(let items):
            socialMenu = items
        }
    }
}

// MARK: - Conformances

extension HomeState: Equatable {
    
    static func == (lhs: HomeState, rhs: HomeState) -> Bool {
        lhs.profile == rhs.profile
            && lhs.homeMenu == rhs.homeMenu
            && lhs.socialMenu == rhs.socialMenu
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension HomeState: ObservableObject {}
#endif
