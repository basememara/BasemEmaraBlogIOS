//
//  ListFavoritesRender.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-06.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

struct ListFavoritesRender: ListFavoritesRenderType {
    private let render: SceneRenderType
    private weak var presentationContext: UIViewController?
    
    init(render: SceneRenderType, presentationContext: UIViewController?) {
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
