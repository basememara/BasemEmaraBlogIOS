//
//  AppState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-14.
//

class AppState {
    private(set) var mainState = MainState()
    private(set) var homeState = HomeState()
    private(set) var showBlogState = ShowBlogState()
    private(set) var showPostState = ShowPostState()
    private(set) var listFavoritesState = ListFavoritesState()
    private(set) var listPostsState = ListPostsState()
    private(set) var listTermsState = ListTermsState()
    private(set) var searchPostsState = SearchPostsState()
    private(set) var showMoreState = ShowMoreState()
    private(set) var showSettingsState = ShowSettingsState()
}
