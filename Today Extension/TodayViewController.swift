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
import ZamzamKit

class TodayViewController: ControllerModuleDelegate, HasDependencies, CoreInjection, NCWidgetProviding {
    
    // MARK: - Controls
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var featuredImage: UIImageView!
    
    // MARK: - VIP variables
    
    private lazy var interactor: TodayBusinessLogic = TodayInteractor(
        presenter: TodayPresenter(viewController: self),
        postWorker: dependencies.resolve(),
        mediaWorker: dependencies.resolve()
    )
    
    // MARK: - Internal variable
    
    private lazy var dataWorker: DataWorkerType = dependencies.resolve()
    
    // MARK: - Controller cycle
    
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

// MARK: - Events

private extension TodayViewController {
    
    func configure() {
        inject(dependencies: AppConfigurator())
        dataWorker.configure()
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(widgetTapped))
        )
    }
    
    func loadData() {
        interactor.fetchLatestPosts(
            with: TodayModels.Request(count: 1)
        )
    }
}

// MARK: - VIP cycle

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
