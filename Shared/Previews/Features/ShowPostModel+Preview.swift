//
//  ShowPostModel+Preview.swift
//  iOS
//
//  Created by Basem Emara on 2020-11-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSBundle

extension ShowPostModel {
    
    static let preview = ShowPostModel().apply { model in
        let presenter = ShowPostPresenter(
            model,
            constants: AppPreviews.shared.core.constants(),
            templateFile: Bundle.main.string(file: "post.html"),
            styleSheetFile: Bundle.main.string(file: "style.css")
        )
        
        AppPreviews.shared.core.dataSeed().fetch {
            guard case .success(let data) = $0, let post = data.posts.first else { return }
            
            presenter.displayPost(
                for: ShowPostAPI.Response(
                    post: post,
                    media: data.media.first { $0.id == post.mediaID },
                    categories: data.terms.filter { $0.taxonomy == .category },
                    tags: data.terms.filter { $0.taxonomy == .tag },
                    author: data.authors.first,
                    favorite: true
                )
            )
        }
    }
}
