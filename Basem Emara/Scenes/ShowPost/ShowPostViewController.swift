//
//  ShowPostViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-01.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import WebKit
import SwiftyPress
import ZamzamKit

class ShowPostViewController: UIViewController, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
            //webView.uiDelegate = self
            webView.scrollView.delegate = self
            
            // Add space to bottom
            webView.scrollView.contentInset.bottom += 60
        }
    }
    
    private lazy var activityIndicatorView = view.makeActivityIndicator()
    
    private lazy var favoriteBarButton = UIBarButtonItem(
        imageName: "star",
        target: self,
        action: #selector(favoriteTapped)
    )
    
    private lazy var commentBarButton = UIBarButtonItem(
        imageName: "comments",
        target: self,
        action: #selector(commentsTapped)
    )
    
    // MARK: - Scene variables
    
    private lazy var interactor: ShowPostBusinessLogic = ShowPostInteractor(
        presenter: ShowPostPresenter(viewController: self),
        postsWorker: dependencies.resolveWorker(),
        mediaWorker: dependencies.resolveWorker(),
        authorsWorker: dependencies.resolveWorker(),
        taxonomyWorker: dependencies.resolveWorker()
    )
    
    private lazy var router: ShowPostRoutable = ShowPostRouter(
        viewController: self
    )
    
    // MARK: - Internal variable
    
    private let baseURL = URL(string: "http://basememara.com") //TODO
    
    var postID: Int! //Must assign or die
    
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
            UIBarButtonItem(imageName: "related", target: self, action: #selector(relatedTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            commentBarButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            favoriteBarButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        ]
        
        activityIndicatorView.startAnimating()
    }
    
    func loadData() {
        interactor.fetchPost(
            with: ShowPostModels.Request(postID: postID)
        )
    }
}

// MARK: - Scene cycle

extension ShowPostViewController: ShowPostDisplayable {
    
    func displayPost(with viewModel: ShowPostModels.ViewModel) {
        title = viewModel.title
        
        webView.loadHTMLString(
            viewModel.content,
            baseURL: URL(string: viewModel.baseURL)
        )
    }
    
    func displayByURL(with viewModel: ShowPostModels.WebViewModel) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
        
        if let postID = viewModel.postID {
            activityIndicatorView.startAnimating()
            
            self.postID = postID
            
            interactor.fetchPost(
                with: ShowPostModels.Request(postID: postID)
            )
            
            return viewModel.decisionHandler(.cancel)
        }
        
        if let termID = viewModel.termID {
            router.listPosts(for: .terms([termID]))
            return viewModel.decisionHandler(.cancel)
        }
        
        title = nil
        activityIndicatorView.startAnimating()
        viewModel.decisionHandler(.allow)
    }
}

// MARK: - Interactions

private extension ShowPostViewController {
    
    @objc func favoriteTapped() {
        
    }
    
    @objc func commentsTapped() {
        
    }
    
    @objc func relatedTapped() {
        
    }
    
    @objc func shareTapped() {
        
    }
    
    @objc func backTapped() {
        
    }
}

// MARK: - Delegates

extension ShowPostViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let requestURL = navigationAction.request.url, navigationAction.navigationType == .linkActivated else {
            return decisionHandler(.allow)
        }
        
        // Open same domain links within app
        guard requestURL.host == baseURL?.host else {
            // Open external links in browser
            present(safari: requestURL.absoluteString)
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
