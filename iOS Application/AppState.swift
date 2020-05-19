//
//  AppState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-14.
//

class AppState {
    let sharedState = SharedState()
    
    let mainState = MainState()
    let homeState = HomeState()
    let showPostState = ShowPostState()
    let listFavoritesState = ListFavoritesState()
    let listPostsState = ListPostsState()
    let listTermsState = ListTermsState()
    let searchPostsState = SearchPostsState()
    let showMoreState = ShowMoreState()
    let showSettingsState = ShowSettingsState()
    
    private(set) lazy var showBlogState = ShowBlogState(
        sharedState: sharedState
    )
}
