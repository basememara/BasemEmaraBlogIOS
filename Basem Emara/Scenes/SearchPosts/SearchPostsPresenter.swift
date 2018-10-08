//
//  SearchPostsPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct SearchPostsPresenter: SearchPostsPresentable {
    private weak var viewController: SearchPostsDisplayable?
    
    private let dateFormatter = DateFormatter().with {
        $0.dateStyle = .medium
        $0.timeStyle = .none
    }
    
    init(viewController: SearchPostsDisplayable?) {
        self.viewController = viewController
    }
}

extension SearchPostsPresenter {

    func presentSearchResults(for response: SearchPostsModels.Response) {
        let viewModels = response.posts.map { post in
            PostsDataViewModel(
                from: post,
                media: response.media.first { $0.id == post.mediaID },
                dateFormatter: self.dateFormatter
            )
        }
        
        viewController?.displayPosts(with: viewModels)
    }
    
    func presentSearchResults(error: DataError) {
        let viewModel = AppModels.Error(
            title: .localized(.searchErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}
