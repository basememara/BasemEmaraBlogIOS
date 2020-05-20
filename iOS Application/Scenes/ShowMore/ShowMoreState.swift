//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

class ShowMoreState: StateRepresentable {
    
    private(set) var moreMenu: [ShowMoreAPI.MenuSection] = [] {
        willSet {
            guard newValue != moreMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != moreMenu else { return }
            notificationPost(keyPath: \ShowMoreState.moreMenu)
        }
    }
    
    private(set) var socialMenu: [ShowMoreAPI.SocialItem] = [] {
        willSet {
            guard newValue != socialMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != socialMenu else { return }
            notificationPost(keyPath: \ShowMoreState.socialMenu)
        }
    }
}

// MARK: - Action

enum ShowMoreAction: Action {
    case loadMenu([ShowMoreAPI.MenuSection])
    case loadSocial([ShowMoreAPI.SocialItem])
}

// MARK: - Reducer

extension ShowMoreState {
    
    func reduce(_ action: ShowMoreAction) {
        switch action {
        case .loadMenu(let sections):
            moreMenu = sections
        case .loadSocial(let social):
            socialMenu = social
        }
    }
}

// MARK: - Conformances

extension ShowMoreState: Equatable {
    
    static func == (lhs: ShowMoreState, rhs: ShowMoreState) -> Bool {
        lhs.moreMenu == rhs.moreMenu
            && lhs.socialMenu == rhs.socialMenu
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ShowMoreState: ObservableObject {}
#endif
