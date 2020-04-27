//
//  ShowPostRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamUI

struct ShowPostRender: ShowPostRenderType {
    private let render: SceneRenderType
    private let theme: Theme
    
    private weak var presentationContext: UIViewController?
    private weak var listPostsDelegate: ListPostsDelegate?
    
    init(
        render: SceneRenderType,
        theme: Theme,
        presentationContext: UIViewController?,
        listPostsDelegate: ListPostsDelegate?
    ) {
        self.render = render
        self.theme = theme
        self.presentationContext = presentationContext
        self.listPostsDelegate = listPostsDelegate
    }
}

extension ShowPostRender {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = render.listPosts(
            params: params,
            delegate: listPostsDelegate
        )
        
        presentationContext?.show(controller)
    }
}

extension ShowPostRender {
    
    func show(url: String) {
        presentationContext?.modal(safari: url, theme: theme)
    }
}
