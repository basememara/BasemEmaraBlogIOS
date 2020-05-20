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
    private let dispatch: Dispatcher<ShowPostAction>
    private let constants: Constants
    private let templateFile: String?
    private let styleSheetFile: String?
    private let dateFormatter: DateFormatter
    
    init(
        dispatch: @escaping Dispatcher<ShowPostAction>,
        constants: Constants,
        templateFile: String?,
        styleSheetFile: String?
    ) {
        self.dispatch = dispatch
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
                commentCount: response.post.commentCount
            )
            
            dispatch(.loadPost(viewModel))
            dispatch(.loadFavorite(response.favorite))
        } catch {
            displayPost(error: .parseFailure(error))
        }
    }
    
    func displayPost(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.blogPostErrorTitle),
            message: error.localizedDescription
        )
        
        dispatch(.loadError(viewModel))
    }
}

extension ShowPostPresenter {
    
    func displayByURL(for response: ShowPostAPI.FetchWebResponse) {
        let viewModel = ShowPostAPI.WebViewModel(
            postID: response.post?.id,
            termID: response.term?.id,
            decisionHandler: response.decisionHandler
        )
        
        dispatch(.loadWeb(viewModel))
    }
}

extension ShowPostPresenter {
    
    func displayToggleFavorite(for response: ShowPostAPI.FavoriteResponse) {
        dispatch(.toggleFavorite(response.favorite))
    }
}
