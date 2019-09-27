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
    private weak var viewController: ShowPostDisplayable?
    
    private let constants: ConstantsType
    private let templateFile = Bundle.main.string(file: "post.html")
    private let styleSheetFile = Bundle.main.string(file: "style.css")
    
    private let dateFormatter = DateFormatter().with {
        $0.dateStyle = .medium
        $0.timeStyle = .none
    }
    
    init(viewController: ShowPostDisplayable?, constants: ConstantsType) {
        self.viewController = viewController
        self.constants = constants
    }
}

extension ShowPostPresenter {
    
    func presentPost(for response: ShowPostAPI.Response) {
        guard let templateString = templateFile else {
            return presentPost(error: .parseFailure(nil))
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
            
            viewController?.displayPost(
                with: ShowPostAPI.ViewModel(
                    title: response.post.title,
                    link: response.post.link,
                    content: try template.render(context),
                    commentCount: response.post.commentCount,
                    favorite: response.favorite
                )
            )
        } catch {
            presentPost(error: .parseFailure(error))
        }
    }
    
    func presentPost(error: DataError) {
        let viewModel = AppModels.Error(
            title: .localized(.blogPostErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}

extension ShowPostPresenter {
    
    func presentByURL(for response: ShowPostAPI.FetchWebResponse) {
        viewController?.displayByURL(
            with: ShowPostAPI.WebViewModel(
                postID: response.post?.id,
                termID: response.term?.id,
                decisionHandler: response.decisionHandler
            )
        )
    }
}

extension ShowPostPresenter {
    
    func presentToggleFavorite(for response: ShowPostAPI.FavoriteResponse) {
        viewController?.display(isFavorite: response.favorite)
    }
}
