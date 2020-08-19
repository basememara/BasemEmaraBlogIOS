//
//  AppStore.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-14.
//

import ZamzamUI

class AppStore {
    let postsState = PostsState()
    let termsState = TermsState()
    
    let mainState = MainState()
    let homeState = HomeState()
    let searchPostsState = SearchPostsState()
    let listTermsState = ListTermsState()
    let showMoreState = ShowMoreState()
    let showSettingsState = ShowSettingsState()
    
    private(set) lazy var showBlogState = ShowBlogState(
        postsState: postsState,
        termsState: termsState
    )
    
    private(set) lazy var listPostsState = ListPostsState(
        postsState: postsState
    )
    
    private(set) lazy var showPostState = ShowPostState(
        postsState: postsState
    )
    
    private(set) lazy var listFavoritesState = ListFavoritesState(
        postsState: postsState
    )
}
