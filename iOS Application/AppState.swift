//
//  AppState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-14.
//

final class AppState {
    let sharedState = SharedState()
    
    let mainState = MainState()
    let homeState = HomeState()
    let listTermsState = ListTermsState()
    let searchPostsState = SearchPostsState()
    let showMoreState = ShowMoreState()
    let showSettingsState = ShowSettingsState()
    
    private(set) lazy var showBlogState = ShowBlogState(
        sharedState: sharedState
    )
    
    private(set) lazy var listPostsState = ListPostsState(
        sharedState: sharedState
    )
    
    private(set) lazy var showPostState = ShowPostState(
        sharedState: sharedState
    )
    
    private(set) lazy var listFavoritesState = ListFavoritesState(
        sharedState: sharedState
    )
}
