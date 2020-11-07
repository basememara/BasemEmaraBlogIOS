//
//  TodayViewController.swift
//  Today Extension
//
//  Created by Basem Emara on 2018-05-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Combine
import NotificationCenter
import SwiftyPress
import UIKit
import ZamzamCore
import ZamzamUI

class TodayViewController: UIViewController, NCWidgetProviding {
    private let core = AppCore()
    private let state = TodayState()
    
    private lazy var action: TodayInteractable? = TodayAction(
        presenter: TodayPresenter(model: state),
        postRepository: core.postRepository(),
        mediaRepository: core.mediaRepository()
    )
    
    private lazy var dataRepository = core.dataRepository()
    private lazy var theme = core.theme()
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Controls
    
    private lazy var titleLabel = UILabel().apply {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.numberOfLines = 1
        $0.minimumScaleFactor = 0.5
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var detailLabel = UILabel().apply {
        $0.font = .systemFont(ofSize: 12)
        $0.numberOfLines = 3
    }
    
    private lazy var captionLabel = UILabel().apply {
        $0.font = .systemFont(ofSize: 10)
        $0.numberOfLines = 1
    }
    
    private lazy var featuredImage = UIImageView(imageNamed: .placeholder).apply {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.cornerRadius = 3
    }
    
    // MARK: - Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Setup data storage
        dataRepository.configure()
        
        // Set theme before views loaded into hierarchy
        TodayStyles.apply(theme)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observe()
        fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellable.removeAll()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.newData)
    }
}

// MARK: - Setup

private extension TodayViewController {
    
    func prepare() {
        // Configure controls
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(widgetTapped))
        )
        
        // Compose layout
        let stackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel.apply {
                    $0.setContentHuggingPriority(.init(rawValue: 750), for: .vertical)
                    $0.setContentCompressionResistancePriority(.init(rawValue: 999), for: .vertical)
                },
                detailLabel.apply {
                    $0.setContentHuggingPriority(.init(rawValue: 749), for: .vertical)
                },
                UIView().apply {
                    $0.backgroundColor = .clear
                    $0.setContentHuggingPriority(.init(rawValue: 1), for: .vertical)
                    $0.setContentCompressionResistancePriority(.init(rawValue: 1), for: .vertical)
                },
                captionLabel
            ]).apply {
                $0.axis = .vertical
                $0.distribution = .fill
                $0.alignment = .fill
                $0.spacing = 3
            },
            featuredImage
        ]).apply {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 8
        }
        
        view.addSubview(stackView)
        stackView.edges(to: view, padding: 12)
        
        featuredImage.translatesAutoresizingMaskIntoConstraints = false
        featuredImage.widthAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    func observe() {
        state.$posts
            .compactMap { $0 }
            .sink(receiveValue: load)
            .store(in: &cancellable)
        
        state.$error
            .sink(receiveValue: load)
            .store(in: &cancellable)
    }
    
    func fetch() {
        action?.fetchLatestPosts(
            with: TodayAPI.Request(maxLength: 1)
        )
    }
}

private extension TodayViewController {
    
    func load(posts: [PostsDataViewModel]) {
        guard let item = posts.first else { return }
            
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

private extension TodayViewController {
        
    func load(error: ViewError?) {
        titleLabel.text ?= error?.title
        detailLabel.text ?= error?.message
    }
}

// MARK: - Interactions

private extension TodayViewController {
    
    @objc func widgetTapped() {
        guard let link = state.posts?.first?.link,
            let url = URL(string: link) else {
                return
        }
        
        extensionContext?.open(url)
    }
}
