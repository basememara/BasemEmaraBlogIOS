//
//  ShowPostState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-27.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

class ShowPostState: StateRepresentable {
    
    private(set) var web: ShowPostAPI.WebViewModel? {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowPostState.web) }
    }
    
    private(set) var post: ShowPostAPI.PostViewModel? {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowPostState.post) }
    }
    
    private(set) var favorite: Bool = false {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowPostState.favorite) }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet { if #available(iOS 13, *) { combineSend() } }
        didSet { notificationPost(keyPath: \ShowPostState.error) }
    }
}

// MARK: - Action

enum ShowPostAction: Action {
    case loadWeb(ShowPostAPI.WebViewModel)
    case loadPost(ShowPostAPI.PostViewModel)
    case favorite(Bool)
    case loadError(AppAPI.Error?)
}

// MARK: - Reducer

extension ShowPostState {
    
    func reduce(_ action: ShowPostAction) {
        switch action {
        case .loadWeb(let item):
            web = item
        case .loadPost(let item):
            post = item
        case .favorite(let item):
            favorite = item
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - Conformances

extension ShowPostState: Equatable {
    
    static func == (lhs: ShowPostState, rhs: ShowPostState) -> Bool {
        lhs.web == rhs.web
            && lhs.post == rhs.post
            && lhs.favorite == rhs.favorite
            && lhs.error == rhs.error
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ShowPostState: ObservableObject {}
#endif
