//
//  AppState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-14.
//

import Foundation.NSNotification
import SwiftyPress

class AppState: StateRepresentable {
    
    // MARK: - Observables
    
    private(set) var allPosts: [PostsDataViewModel] = [] {
        willSet {
            guard newValue != allPosts, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != allPosts else { return }
            notificationPost(for: \Self.allPosts)
        }
    }
    
    private(set) var allTerms: [TermsDataViewModel] = [] {
        willSet {
            guard newValue != allTerms, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != allTerms else { return }
            notificationPost(for: \Self.allTerms)
        }
    }
}

// MARK: - Action

enum AppAction: Action {
    case mergePosts([PostsDataViewModel])
    case mergeTerms([TermsDataViewModel])
    case toggleFavorite(postID: Int, favorite: Bool)
}

// MARK: - Reducer

extension AppState {
    
    func callAsFunction(_ action: AppAction) {
        switch action {
        case .mergePosts(let items):
            let ids = items.map(\.id)
            allPosts = allPosts.filter { !ids.contains($0.id) } + items
        case .mergeTerms(let items):
            let ids = items.map(\.id)
            allTerms = allTerms.filter { !ids.contains($0.id) } + items
        case .toggleFavorite(let postID, let favorite):
            guard let current = allPosts
                .first(where: { $0.id == postID })?
                .toggled(favorite: favorite) else {
                    return
            }
            
            self(.mergePosts([current]))
        }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension AppState: ObservableObject {}
#endif
