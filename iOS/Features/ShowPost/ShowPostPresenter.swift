//
//  ShowPostPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftyPress
import ZamzamUI
import Stencil
import SystemConfiguration

struct ShowPostPresenter: ShowPostPresentable {
    private let store: StoreReducer<ShowPostReducer>
    private let constants: Constants
    private let templateFile: String?
    private let styleSheetFile: String?
    private let dateFormatter: DateFormatter
    
    init(
        _ store: @escaping StoreReducer<ShowPostReducer>,
        constants: Constants,
        templateFile: String?,
        styleSheetFile: String?
    ) {
        self.store = store
        self.constants = constants
        self.templateFile = templateFile
        self.styleSheetFile = styleSheetFile
        self.dateFormatter = DateFormatter(dateStyle: .medium)
    }
}

extension ShowPostPresenter {
    
    func displayPost(for response: ShowPostAPI.Response) {
        guard let templateString = templateFile else {
            displayPost(error: .parseFailure(nil))
            return
        }
        
        var context: [String: Any] = [
            "style": SCNetworkReachability.isOnline && !styleSheetFile.isNilOrEmpty
                ? "<link rel='stylesheet' href='\(constants.styleSheet)' type='text/css' media='all' />"
                : "<style>\(styleSheetFile ?? "")</style>",
            "post": ShowPostAPI.PageViewModel(
                title: response.post.title,
                content: response.post.content,
                date: dateFormatter.string(from: response.post.createdAt),
                categories: response.categories.map {
                    "<a href='\(constants.baseURL.absoluteString)/category/\($0.slug)'>\($0.name)</a>"
                },
                tags: response.tags.map {
                    "<a href='\(constants.baseURL.absoluteString)/tag/\($0.slug)'>\($0.name)</a>"
                }
            ),
            "isAffiliate": false
        ]
        
        if let media = response.media {
            context["media"] = media.link
        }
        
        if let author = response.author {
            context["author"] = ShowPostAPI.AuthorViewModel(
                name: author.name,
                content: author.content,
                avatar: author.avatar
            )
        }
        
        do {
            let template = Template(templateString: templateString)
            
            let viewModel = ShowPostAPI.PostViewModel(
                id: response.post.id,
                title: response.post.title,
                link: response.post.link,
                content: try template.render(context),
                commentCount: .localizedStringWithFormat("%i", response.post.commentCount)
            )
            
            store(.loadPost(viewModel))
            store(.loadFavorite(response.favorite))
        } catch {
            displayPost(error: .parseFailure(error))
        }
    }
    
    func displayPost(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.blogPostErrorTitle),
            message: error.localizedDescription
        )
        
        store(.loadError(viewModel))
    }
}

extension ShowPostPresenter {
    
    func displayByURL(for response: ShowPostAPI.FetchWebResponse) {
        let viewModel = ShowPostAPI.WebViewModel(
            postID: response.post?.id,
            termID: response.term?.id,
            decisionHandler: response.decisionHandler
        )
        
        store(.loadWeb(viewModel))
    }
}

extension ShowPostPresenter {
    
    func displayToggleFavorite(for response: ShowPostAPI.FavoriteResponse) {
        store(.toggleFavorite(response.favorite))
    }
}
