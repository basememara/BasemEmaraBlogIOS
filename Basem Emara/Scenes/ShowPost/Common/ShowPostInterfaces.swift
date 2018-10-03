//
//  ShowPostInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol ShowPostBusinessLogic {
    func fetchPost(with request: ShowPostModels.Request)
    func fetchByURL(with request: ShowPostModels.FetchWebRequest)
}

protocol ShowPostPresentable {
    func presentPost(for response: ShowPostModels.Response)
    func presentPost(error: DataError)
    
    func presentByURL(for response: ShowPostModels.FetchWebResponse)
}

protocol ShowPostDisplayable: class, AppDisplayable {
    func displayPost(with viewModel: ShowPostModels.ViewModel)
    func displayByURL(with viewModel: ShowPostModels.WebViewModel)
}

protocol ShowPostRoutable: AppRoutable {
    func listPosts(for fetchType: ListPostsViewController.FetchType)
}
