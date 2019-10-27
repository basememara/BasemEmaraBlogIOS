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

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - Controls
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var featuredImage: UIImageView!
    
    // MARK: - Dependencies
    
    private let dependencies = Dependencies {
        Module { AppModule() as SwiftyPressModule }
        Module { TodayModule() as TodayModuleType }
    }
    
    @Inject private var module: TodayModuleType
    
    private lazy var action: TodayActionable = module.component(with: self)
    private lazy var dataWorker: DataWorkerType = module.component()
    
    // MARK: - Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
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
    
    func commonInit() {
        // Register dependency graph
        dependencies.build()
        
        // Setup data storage
        dataWorker.configure()
        
        // Set theme before views loaded into hierarchy
        TodayStyles.apply(module.component())
    }
    
    func configure() {
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
