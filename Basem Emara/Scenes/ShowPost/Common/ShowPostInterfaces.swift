//
//  ShowPostInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

protocol ShowPostBusinessLogic: AppBusinessLogic {
    func fetchPost(with request: ShowPostModels.Request)
    func fetchByURL(with request: ShowPostModels.FetchWebRequest)
    func toggleFavorite(with request: ShowPostModels.FavoriteRequest)
}

protocol ShowPostPresentable: AppPresentable {
    func presentPost(for response: ShowPostModels.Response)
    func presentPost(error: DataError)
    
    func presentByURL(for response: ShowPostModels.FetchWebResponse)
    
    func presentToggleFavorite(for response: ShowPostModels.FavoriteResponse)
}

protocol ShowPostDisplayable: class, AppDisplayable {
    func displayPost(with viewModel: ShowPostModels.ViewModel)
    func displayByURL(with viewModel: ShowPostModels.WebViewModel)
    func display(isFavorite: Bool)
}

protocol ShowPostRoutable: AppRoutable {
    func listPosts(params: ListPostsModels.Params)
}

/// Delegate for target controller to pass data back
protocol ShowPostViewControllerDelegate: class {
    func update(postID: Int)
}
