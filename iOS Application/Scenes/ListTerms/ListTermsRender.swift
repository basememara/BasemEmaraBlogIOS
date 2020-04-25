//
//  ListTermsRouter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit.UIViewController

struct ListTermsRender: ListTermsRenderType {
    private let render: SceneRenderType
    private weak var presentationContext: UIViewController?
    
    init(render: SceneRenderType, presentationContext: UIViewController?) {
        self.render = render
        self.presentationContext = presentationContext
    }
}

extension ListTermsRender {
    
    func listPosts(params: ListPostsAPI.Params) {
        let controller = render.listPosts(params: params)
        presentationContext?.show(controller)
    }
}
