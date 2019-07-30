//
//  ShowPostPreviewViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class PreviewPostViewController: UIViewController, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var featuredImage: UIImageView!
    
    // MARK: - Internal variable
    
    private lazy var postWorker: PostWorkerType = dependencies.resolve()
    private lazy var constants: ConstantsType = dependencies.resolve()
    
    var viewModel: PostsDataViewModel?
    weak var delegate: UIViewController?
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        return makePreviewActionItems()
    }
}

// MARK: - Events

private extension PreviewPostViewController {
    
    func configure() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.summary
        featuredImage.setImage(from: viewModel.imageURL)
    }
}

// MARK: - Helpers

private extension PreviewPostViewController {
    
    func makePreviewActionItems() -> [UIPreviewActionItem] {
        guard let viewModel = viewModel else { return [] }
            
        let isFavorite = postWorker.hasFavorite(id: viewModel.id)
        let title: String = isFavorite ? .localized(.unfavoriteTitle) : .localized(.favoriteTitle)
        let style: UIPreviewAction.Style = isFavorite ? .destructive : .default
        
        return [
            UIPreviewAction(title: title, style: style) { [weak self] _, _ in
                guard let self = self else { return }
                self.postWorker.toggleFavorite(id: viewModel.id)
            },
            UIPreviewAction(title: .localized(.commentsTitle), style: .default) { [weak self] _, _ in
                guard let self = self else { return }
                self.delegate?.present(
                    safari: self.constants.baseURL
                        .appendingPathComponent("mobile-comments")
                        .appendingQueryItem("postid", value: viewModel.id)
                        .absoluteString,
                    theme: self.dependencies.resolve()
                )
            },
            UIPreviewAction(title: .localized(.shareTitle), style: .default) { [weak self] _, _ in
                guard let self = self,
                    let url = URL(string: viewModel.link),
                    let delegateView = self.delegate?.view else {
                        return
                }
                
                self.delegate?.present(
                    activities: [viewModel.title.htmlDecoded, url],
                    popoverFrom: delegateView
                )
            }
        ]
    }
}
