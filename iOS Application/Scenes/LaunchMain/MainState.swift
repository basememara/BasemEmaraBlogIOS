//
//  MainModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

class MainState: StateRepresentable {
    
    private(set) var tabMenu: [MainAPI.TabItem] = [] {
        willSet {
            guard newValue != tabMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != tabMenu else { return }
            notificationPost(keyPath: \MainState.tabMenu)
        }
    }
}

// MARK: - Action

enum MainAction: Action {
    case loadMenu([MainAPI.TabItem])
}

// MARK: - Reducer

extension MainState {
    
    func reduce(_ action: MainAction) {
        switch action {
        case .loadMenu(let menu):
            tabMenu = menu
        }
    }
}

// MARK: - Conformances

extension MainState: Equatable {
    
    static func == (lhs: MainState, rhs: MainState) -> Bool {
        lhs.tabMenu == rhs.tabMenu
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension MainState: ObservableObject {}
#endif
