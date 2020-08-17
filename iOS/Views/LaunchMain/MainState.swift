//
//  MainModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import ZamzamUI

class MainState: StateRepresentable {
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var tabMenu: [MainAPI.TabItem] = [] {
        willSet {
            guard newValue != tabMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != tabMenu else { return }
            notificationPost(for: \Self.tabMenu)
        }
    }
}

extension MainState {
    
    func subscribe(_ observer: @escaping (StateChange<MainState>) -> Void) {
        subscribe(observer, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

// MARK: - Reducer

enum MainReducer: Reducer {
    case loadMenu([MainAPI.TabItem])
}

extension MainState {
    
    func callAsFunction(_ reducer: MainReducer) {
        switch reducer {
        case .loadMenu(let menu):
            tabMenu = menu
        }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension MainState: ObservableObject {}
#endif
