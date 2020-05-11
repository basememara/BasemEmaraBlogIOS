//
//  ShowPostState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-27.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ShowPostState: State {
    private(set) var web: ShowPostAPI.WebViewModel?
    private(set) var post: ShowPostAPI.PostViewModel?
    private(set) var favorite: Bool = false
    private(set) var error: AppAPI.Error?
}

// MARK: - Reducer

extension ShowPostState {
    
    enum ShowPostAction: Action {
        case loadWeb(ShowPostAPI.WebViewModel)
        case loadPost(ShowPostAPI.PostViewModel)
        case favorite(Bool)
        case loadError(AppAPI.Error?)
    }
    
    mutating func receive(_ action: ShowPostAction) {
        switch action {
        case .loadWeb(let value):
            web = value
        case .loadPost(let value):
            post = value
        case .favorite(let value):
            favorite = value
        case .loadError(let value):
            error = value
        }
    }
}
