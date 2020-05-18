//
//  SearchPostsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit.UIViewController

struct SearchPostsRender: SearchPostsRenderable {
    private let render: SceneRenderable
    weak var presentationContext: UIViewController?
    
    init(render: SceneRenderable, presentationContext: UIViewController?) {
        self.render = render
        self.presentationContext = presentationContext
    }
}

extension SearchPostsRender {

    func showPost(for model: PostsDataViewModel) {
        let controller = render.showPost(for: model.id)
        presentationContext?.show(controller)
    }
}
