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
import Shank
import SwiftyPress
import ZamzamUI

class ShowPostViewController: UIViewController, StatusBarable {
    
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
        imageName: UIImage.ImageName.favoriteEmpty.rawValue,
        target: self,
        action: #selector(favoriteTapped)
    )
    
    private lazy var commentBarButton = BadgeBarButtonItem(
        image: UIImage(named: .comments),
        badgeText: nil,
        target: self,
        action: #selector(commentsTapped)
    )
    
    // MARK: - Scene variables
    
    private lazy var action: ShowPostActionable = module.resolve(with: self)
    
    private lazy var router: ShowPostRoutable = module.resolve(
        with: ShowPostAPI.RoutableInputs(
            viewController: self,
            listPostsDelegate: self
        )
    )
    
    // MARK: - Internal variable
    
    @Inject private var module: ShowPostModuleType
    @Inject private var notificationCenter: NotificationCenter
    @Inject private var constants: ConstantsType
    @Inject private var theme: Theme
    
    private var viewModel: ShowPostAPI.ViewModel?
    private var history = [Int]()
    
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
        
        action.fetchPost(
            with: ShowPostAPI.Request(postID: postID)
        )
    }
}

extension ShowPostViewController: ShowPostLoadable {
    
    func loadData(for id: Int) {
        if let lastPostID = postID {
            history.append(lastPostID)
        }
        
        postID = id
        loadData()
    }
}

// MARK: - Scene cycle

extension ShowPostViewController: ShowPostDisplayable {
    
    func displayPost(with viewModel: ShowPostAPI.ViewModel) {
        self.viewModel = viewModel
        
        title = viewModel.title
        commentBarButton.badgeText = "\(viewModel.commentCount)"
        display(isFavorite: viewModel.favorite)
        
        webView.loadHTMLString(
            viewModel.content,
            baseURL: constants.baseURL
        )
    }
    
    func displayByURL(with viewModel: ShowPostAPI.WebViewModel) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
        
        if let postID = viewModel.postID {
            loadData(for: postID)
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
            ? UIImage(named: .favoriteFilled)
            : UIImage(named: .favoriteEmpty)
    }
}

// MARK: - Interactions

private extension ShowPostViewController {
    
    @objc func favoriteTapped() {
        guard let postID = postID else { return }
        
        action.toggleFavorite(
            with: ShowPostAPI.FavoriteRequest(
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
        
        router.present(safari: url, theme: theme)
    }
    
    @objc func shareTapped(_ sender: UIBarButtonItem) {
        guard let title = viewModel?.title,
            let link = viewModel?.link,
            let url = URL(string: link) else {
                return
        }
        
        let safariActivity = UIActivity.make(
            title: .localized(.openInSafari),
            imageName: UIImage.ImageName.safariShare.rawValue,
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
        
        action.fetchPost(
            with: ShowPostAPI.Request(postID: lastPostID)
        )
    }
    
    @objc func deviceOrientationDidChange() {
        removeStatusBar()
        showStatusBar()
    }
}

// MARK: - Delegates

extension ShowPostViewController: ListPostsDelegate {
    
    func listPosts(_ viewController: UIViewController, didSelect postID: Int) {
        loadData(for: postID)
        viewController.dismissOrPop()
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
            present(safari: requestURL.absoluteString, theme: theme)
            return decisionHandler(.cancel)
        }
        
        action.fetchByURL(
            with: ShowPostAPI.FetchWebRequest(
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
