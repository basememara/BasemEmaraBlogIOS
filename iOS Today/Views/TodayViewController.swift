//
//  TodayViewController.swift
//  Today Extension
//
//  Created by Basem Emara on 2018-05-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import NotificationCenter
import SwiftyPress
import ZamzamCore
import ZamzamUI

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - Controls
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var featuredImage: UIImageView!
    
    // MARK: - Dependencies
    
    private let container = Dependencies {
        Module { AppModule() as SwiftyPressModule }
    }
    
    @Inject private var module: SwiftyPressModule
    
    private lazy var action: TodayActionable = TodayAction(
        presenter: TodayPresenter(viewController: self),
        postWorker: module.component(),
        mediaWorker: module.component()
    )
    
    private lazy var dataWorker: DataWorkerType = module.component()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.newData)
    }
}

// MARK: - Setup

private extension TodayViewController {
    
    func configure() {
        container.build()
        dataWorker.configure()
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(widgetTapped))
        )
    }
    
    func loadData() {
        action.fetchLatestPosts(
            with: TodayAPI.Request(maxLength: 1)
        )
    }
}

// MARK: - Scene

extension TodayViewController: TodayDisplayable {
    
    func displayLatestPosts(with viewModels: [PostsDataViewModel]) {
        guard let item = viewModels.first else { return }
        
        titleLabel.text = item.title
        detailLabel.text = item.summary
        captionLabel.text = item.date
        
        if let url = item.imageURL {
            featuredImage.setImage(
                from: url,
                referenceSize: featuredImage.frame.size,
                contentMode: .aspectFill
            )
        }
    }
}

// MARK: - Interactions

private extension TodayViewController {
    
    @objc func widgetTapped() {
        guard let url = URL(string: "basememara:") else { return }
        extensionContext?.open(url)
    }
}
