//
//  TodayState.swift
//  BasemEmara iOS Today
//
//  Created by Basem Emara on 2020-05-23.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress

class TodayState: StateRepresentable {
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var posts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != posts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != posts else { return }
            notificationPost(for: \Self.posts)
        }
    }
    
    private(set) var error: ViewError? {
        willSet {
            guard newValue != error, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != error else { return }
            notificationPost(for: \Self.error)
        }
    }
}

extension TodayState {
    
    func subscribe(_ observer: @escaping (StateChange<TodayState>) -> Void) {
        subscribe(observer, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

// MARK: - Action

enum TodayAction: Action {
    case loadPosts([PostsDataViewModel])
    case loadError(ViewError)
}

// MARK: - Reducer

extension TodayState {
    
    func callAsFunction(_ action: TodayAction) {
        switch action {
        case .loadPosts(let items):
            posts = items
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension TodayState: ObservableObject {}
#endif
