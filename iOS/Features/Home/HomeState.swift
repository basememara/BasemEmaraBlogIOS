//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import ZamzamUI

class HomeState: StateRepresentable {
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    fileprivate(set) var profile: HomeAPI.Profile? {
        willSet {
            guard newValue != profile, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != profile else { return }
            notificationPost(for: \Self.profile)
        }
    }
    
    fileprivate(set) var homeMenu: [HomeAPI.MenuSection] = [] {
        willSet {
            guard newValue != homeMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != homeMenu else { return }
            notificationPost(for: \Self.homeMenu)
        }
    }
    
    fileprivate(set) var socialMenu: [HomeAPI.SocialItem] = [] {
        willSet {
            guard newValue != socialMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != socialMenu else { return }
            notificationPost(for: \Self.socialMenu)
        }
    }
}

extension HomeState {
    
    func subscribe(_ observer: @escaping (StateChange<HomeState>) -> Void) {
        subscribe(observer, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension HomeState: ObservableObject {}
#endif

// MARK: - Reducer

enum HomeReducer: Reducer {
    case loadProfile(HomeAPI.Profile)
    case loadMenu([HomeAPI.MenuSection])
    case loadSocial([HomeAPI.SocialItem])
}

extension AppStore {
    
    func reduce(_ reducer: HomeReducer) {
        switch reducer {
        case .loadProfile(let item):
            homeState.profile = item
        case .loadMenu(let items):
            homeState.homeMenu = items
        case .loadSocial(let items):
            homeState.socialMenu = items
        }
    }
}
