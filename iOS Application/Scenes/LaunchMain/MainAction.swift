//
//  MainAction.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//

enum MainAction: MainActionType {
    case loadMenu([SceneRender.Menu], MainAPI.Layout)
}

// MARK: - Logic

struct MainActionCreator: MainActionCreatorType {
    private let dispatch: (MainAction) -> Void
    
    init(dispatch: @escaping (MainAction) -> Void) {
        self.dispatch = dispatch
    }
}

extension MainActionCreator {

    func fetchMenu(with request: MainAPI.FetchMenuRequest) {
        switch request.layout {
        case .pad:
            dispatch(
                .loadMenu(
                    [.blog, .favorites, .search, .more],
                    request.layout
                )
            )
        default:
            dispatch(
                .loadMenu(
                    [.home, .blog, .favorites, .search, .more],
                    request.layout
                )
            )
        }
    }
}
