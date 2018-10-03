//
//  ShowPostPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit
import Stencil
import SystemConfiguration

struct ShowPostPresenter: ShowPostPresentable {
    private weak var viewController: ShowPostDisplayable?
    
    // TODO: Put into constants
    private let baseURL = "http://basememara.com"
    private let templateFile = Bundle.main.string(file: "post.html")
    private let styleSheetFile = Bundle.main.string(file: "style.css")
    private let styleSheetURL = "http://basememara.com/wp-content/themes/metro-pro/style.css"
    
    private let dateFormatter = DateFormatter().with {
        $0.dateStyle = .medium
        $0.timeStyle = .none
    }
    
    init(viewController: ShowPostDisplayable?) {
        self.viewController = viewController
    }
}

extension ShowPostPresenter {
    
    func presentPost(for response: ShowPostModels.Response) {
        guard let templateString = templateFile else {
            return presentPost(error: .parseFailure(nil))
        }
        
        var context: [String: Any] = [
            "style": SCNetworkReachability.isOnline && !styleSheetFile.isNilOrEmpty
                ? "<link rel='stylesheet' href='\(styleSheetURL)' type='text/css' media='all' />"
                : "<style>\(styleSheetFile!)</style>",
            "post": ShowPostModels.PageViewModel(
                title: response.post.title,
                content: response.post.content,
                date: dateFormatter.string(from: response.post.createdAt),
                categories: response.categories.map {
                    "<a href='\(baseURL)/category/\($0.slug)'>\($0.name)</a>"
                },
                tags: response.tags.map {
                    "<a href='\(baseURL)/tag/\($0.slug)'>\($0.name)</a>"
                }
            ),
            "isAffiliate": false
        ]
        
        if let media = response.media {
            context["media"] = media.link
        }
        
        if let author = response.author {
            context["author"] = ShowPostModels.AuthorViewModel(
                name: author.name,
                content: author.content,
                avatar: author.avatar
            )
        }
        
        do {
            let template = Template(templateString: templateString)
            
            viewController?.displayPost(
                with: ShowPostModels.ViewModel(
                    baseURL: baseURL,
                    title: response.post.title,
                    content: try template.render(context)
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
    
    func presentByURL(for response: ShowPostModels.FetchWebResponse) {
        viewController?.displayByURL(
            with: ShowPostModels.WebViewModel(
                postID: response.post?.id,
                termID: response.term?.id,
                decisionHandler: response.decisionHandler
            )
        )
    }
}
