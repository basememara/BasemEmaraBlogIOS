//
//  ListFavoritesRender.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit.UIViewController

struct ListFavoritesRender: ListFavoritesRenderable {
    private let render: SceneRender
    private weak var presentationContext: UIViewController?
    
    init(render: SceneRender, presentationContext: UIViewController?) {
        self.render = render
        self.presentationContext = presentationContext
    }
}

extension ListFavoritesRender {
    
    func showPost(for model: PostsDataViewModel) {
        let controller = render.showPost(for: model.id)
        presentationContext?.show(controller)
    }
}
