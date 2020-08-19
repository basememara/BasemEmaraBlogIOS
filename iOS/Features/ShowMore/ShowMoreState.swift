//
//  HomeState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-19.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress
import ZamzamUI

class ShowMoreState: StateRepresentable {
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    fileprivate(set) var moreMenu: [ShowMoreAPI.MenuSection] = [] {
        willSet {
            guard newValue != moreMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != moreMenu else { return }
            notificationPost(for: \Self.moreMenu)
        }
    }
    
    fileprivate(set) var socialMenu: [ShowMoreAPI.SocialItem] = [] {
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

extension ShowMoreState {
    
    func subscribe(_ observer: @escaping (StateChange<ShowMoreState>) -> Void) {
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
extension ShowMoreState: ObservableObject {}
#endif

// MARK: - Reducer

enum ShowMoreReducer: Reducer {
    case loadMenu([ShowMoreAPI.MenuSection])
    case loadSocial([ShowMoreAPI.SocialItem])
}

extension AppStore {
    
    func reduce(_ reducer: ShowMoreReducer) {
        switch reducer {
        case .loadMenu(let sections):
            showMoreState.moreMenu = sections
        case .loadSocial(let social):
            showMoreState.socialMenu = social
        }
    }
}
