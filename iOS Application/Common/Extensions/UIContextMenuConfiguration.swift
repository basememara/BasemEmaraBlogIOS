//
//  UIContextMenuConfiguration.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-27.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI

@available(iOS 13.0, *)
extension UIContextMenuConfiguration {
    
    /// Returns context menu ocnfiguration for a blog post.
    convenience init(
        for model: PostsDataViewModel,
        at indexPath: IndexPath,
        from dataView: DataViewable,
        delegate: UIViewController?,
        constants: ConstantsType,
        theme: Theme,
        additionalActions actions: [UIAction] = []
    ) {
        self.init(identifier: NSNumber(value: model.id), previewProvider: nil) { _ in
            UIMenu(
                title: "",
                children: actions + [
                    UIAction(title: .localized(.commentsTitle), image: UIImage(systemName: "text.bubble")) { [weak delegate] _ in
                        delegate?.modal(
                            safari: constants.baseURL
                                .appendingPathComponent("mobile-comments")
                                .appendingQueryItem("postid", value: model.id)
                                .absoluteString,
                            theme: theme
                        )
                    },
                    UIAction(title: .localized(.shareTitle), image: UIImage(systemName: "square.and.arrow.up")) { [weak delegate] _ in
                        guard let delegate = delegate, let url = URL(string: model.link) else { return }

                        delegate.present(
                           activities: [model.title.htmlDecoded, url],
                           popoverFrom: dataView.cellForRow(at: indexPath) ?? delegate.view
                        )
                    }
                ]
            )
        }
    }
}
