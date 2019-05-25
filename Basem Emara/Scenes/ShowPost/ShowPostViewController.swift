//
//  ShowPostViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-01.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import WebKit
import SystemConfiguration
import SwiftyPress
import ZamzamKit

class ShowPostViewController: UIViewController, StatusBarable, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
            webView.scrollView.delegate = self
            webView.scrollView.contentInset.bottom += 60
        }
    }
    
    private lazy var activityIndicatorView = view.makeActivityIndicator()
    
    private lazy var favoriteBarButton = UIBarButtonItem(
        imageName: "favorite-empty",
        target: self,
        action: #selector(favoriteTapped)
    )
    
    private lazy var commentBarButton = BadgeBarButtonItem(
        image: UIImage(named: "comments"),
        badgeText: nil,
        target: self,
        action: #selector(commentsTapped)
    )
    
    // MARK: - Scene variables
    
    private lazy var interactor: ShowPostBusinessLogic = ShowPostInteractor(
        presenter: ShowPostPresenter(
            viewController: self,
            constants: dependencies.resolve()
        ),
        postWorker: dependencies.resolve(),
        mediaWorker: dependencies.resolve(),
        authorWorker: dependencies.resolve(),
        taxonomyWorker: dependencies.resolve()
    )
    
    private lazy var router: ShowPostRoutable = ShowPostRouter(
        viewController: self
    )
    
    // MARK: - Internal variable
    
    private var viewModel: ShowPostModels.ViewModel?
    private lazy var constants: ConstantsType = dependencies.resolve()
    private lazy var notificationCenter: NotificationCenter = dependencies.resolve()
    private lazy var history = [Int]()
    
    var postID: Int?
    let application = UIApplication.shared
    var statusBar: UIView?
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.hidesBarsOnSwipe = false
    }
}

// MARK: - Events

private extension ShowPostViewController {
    
    func configure() {
        toolbarItems = [
            UIBarButtonItem(imageName: "back", target: self, action: #selector(backTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            commentBarButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            favoriteBarButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped(_:)))
        ]
        
        // Status bar background transparent so fill in on scroll
        showStatusBar()
        notificationCenter.addObserver(
            for: UIDevice.orientationDidChangeNotification,
            selector: #selector(deviceOrientationDidChange),
            from: self
        )
    }
    
    func loadData() {
        guard let postID = postID else { return }
        activityIndicatorView.startAnimating()
        
        interactor.fetchPost(
            with: ShowPostModels.Request(postID: postID)
        )
    }
}

// MARK: - Scene cycle

extension ShowPostViewController: ShowPostDisplayable {
    
    func displayPost(with viewModel: ShowPostModels.ViewModel) {
        self.viewModel = viewModel
        
        title = viewModel.title
        commentBarButton.badgeText = "\(viewModel.commentCount)"
        display(isFavorite: viewModel.favorite)
        
        webView.loadHTMLString(
            viewModel.content,
            baseURL: constants.baseURL
        )
    }
    
    func displayByURL(with viewModel: ShowPostModels.WebViewModel) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
        
        if let postID = viewModel.postID {
            activityIndicatorView.startAnimating()
            
            if let lastPostID = self.postID {
                history.append(lastPostID)
            }
            
            self.postID = postID
            
            interactor.fetchPost(
                with: ShowPostModels.Request(postID: postID)
            )
            
            return viewModel.decisionHandler(.cancel)
        }
        
        if let termID = viewModel.termID {
            router.listPosts(params: .init(fetchType: .terms([termID])))
            return viewModel.decisionHandler(.cancel)
        }
        
        title = nil
        activityIndicatorView.startAnimating()
        viewModel.decisionHandler(.allow)
    }
    
    func display(isFavorite: Bool) {
        favoriteBarButton.image = isFavorite
            ? UIImage(named: "favorite-filled")
            : UIImage(named: "favorite-empty")
    }
}

// MARK: - Interactions

private extension ShowPostViewController {
    
    @objc func favoriteTapped() {
        guard let postID = postID else { return }
        
        interactor.toggleFavorite(
            with: ShowPostModels.FavoriteRequest(
                postID: postID
            )
        )
    }
    
    @objc func commentsTapped() {
        guard SCNetworkReachability.isOnline else {
            present(
                alert: .localized(.commentsNotAvailableErrorTitle),
                message: .localized(.notConnectedToInternetErrorMessage)
            )
            
            return
        }
        
        let url = constants.baseURL
            .appendingPathComponent("mobile-comments")
            .appendingQueryItem("postid", value: postID)
            .absoluteString
        
        present(safari: url, theme: dependencies.resolve())
    }
    
    @objc func shareTapped(_ sender: UIBarButtonItem) {
        guard let title = viewModel?.title,
            let link = viewModel?.link,
            let url = URL(string: link) else {
                return
        }
        
        let safariActivity = UIActivity.make(
            title: .localized(.openInSafari),
            imageName: "safari-share",
            imageBundle: .zamzamKit,
            handler: {
                guard SCNetworkReachability.isOnline else {
                    self.present(
                        alert: .localized(.browserNotAvailableErrorTitle),
                        message: .localized(.notConnectedToInternetErrorMessage)
                    )
                    
                    return
                }

                UIApplication.shared.open(url)
            }
        )
        
        present(
            activities: [title.htmlDecoded, link],
            barButtonItem: sender,
            applicationActivities: [safariActivity]
        )
    }
    
    @objc func backTapped() {
        guard let lastPostID = history.popLast() else {
            present(alert: .localized(.noPostInHistoryErrorMessage))
            return
        }
        
        activityIndicatorView.startAnimating()
        postID = lastPostID
        
        interactor.fetchPost(
            with: ShowPostModels.Request(postID: lastPostID)
        )
    }
    
    @objc func deviceOrientationDidChange() {
        removeStatusBar()
        showStatusBar()
    }
}

// MARK: - Delegates

extension ShowPostViewController: ShowPostViewControllerDelegate {
    
    func update(postID: Int) {
        if let lastPostID = self.postID {
            history.append(lastPostID)
        }
        
        self.postID = postID
        loadData()
    }
}

extension ShowPostViewController: WKNavigationDelegate {
    //swiftlint:disable implicitly_unwrapped_optional
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let requestURL = navigationAction.request.url, navigationAction.navigationType == .linkActivated else {
            return decisionHandler(.allow)
        }
        
        // Open same domain links within app
        guard requestURL.host == constants.baseURL.host else {
            // Open external links in browser
            present(safari: requestURL.absoluteString, theme: dependencies.resolve())
            return decisionHandler(.cancel)
        }
        
        interactor.fetchByURL(
            with: ShowPostModels.FetchWebRequest(
                url: requestURL.absoluteString,
                decisionHandler: decisionHandler
            )
        )
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Start the network activity indicator when the web view is loading
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Stop the network activity indicator when the loading finishes
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicatorView.stopAnimating()
    }
}

extension ShowPostViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Display navigation/toolbar when scrolled to the bottom
        guard scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
}
