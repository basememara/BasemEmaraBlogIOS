//
//  ListPostsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit.UIViewController

struct ListPostsRender: ListPostsRenderType {
    private let render: SceneRenderType
    
    private weak var presentationContext: UIViewController?
    private weak var listPostsDelegate: ListPostsDelegate?
    
    init(
        render: SceneRenderType,
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