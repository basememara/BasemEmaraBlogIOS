//
//  ListPostsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit.UIViewController

struct ListPostsRender: ListPostsRenderable {
    private let render: RenderDelegate
    
    private weak var presentationContext: UIViewController?
    private weak var listPostsDelegate: ListPostsDelegate?
    
    init(
        render: RenderDelegate,
        presentationContext: UIViewController?,
        listPostsDelegate: ListPostsDelegate?
    ) {
        self.render = render
        self.presentationContext = presentationContext
        self.listPostsDelegate = listPostsDelegate
    }
}

extension ListPostsRender {
    
    func showPost(for model: PostsDataViewModel) {
        guard let listPostsDelegate = listPostsDelegate,
            let presentationContext = presentationContext else {
                self.presentationContext?.show(
                    render.showPost(for: model.id)
                )
                
                return
        }
        
        listPostsDelegate.listPosts(presentationContext, didSelect: model.id)
    }
}
