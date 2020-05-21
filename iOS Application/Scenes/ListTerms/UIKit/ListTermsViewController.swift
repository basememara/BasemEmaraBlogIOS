//
//  ListTermsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

final class ListTermsViewController: UIViewController {
    private let state: ListTermsState
    private let interactor: ListTermsInteractable?
    private var render: ListTermsRenderable?
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Controls
    
    private lazy var tableView = UITableView().apply {
        $0.register(TermTableViewCell.self)
        $0.contentInset.bottom += 20
    }
    
    private lazy var tableViewAdapter = TermsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    // MARK: - Initializers
    
    init(
        state: ListTermsState,
        interactor: ListTermsInteractable?,
        render: ((UIViewController) -> ListTermsRenderable)?
    ) {
        self.state = state
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        self.render = render?(self)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        state.subscribe(load, in: &cancellable)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellable = nil
    }
}

// MARK: - Setup

private extension ListTermsViewController {
    
    func prepare() {
        // Configure controls
        navigationItem.title = .localized(.listTermsTitle)
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
    }
    
    func fetch() {
        interactor?.fetchTerms(
            with: ListTermsAPI.FetchTermsRequest()
        )
    }
    
    func load(_ keyPath: PartialKeyPath<ListTermsState>?) {
        if keyPath == \ListTermsState.terms || keyPath == nil {
            tableViewAdapter.reloadData(with: state.terms)
        }
        
        if keyPath == \ListTermsState.error {
            present(
                alert: state.error?.title,
                message: state.error?.message
            )
        }
    }
}

// MARK: - Delegates

extension ListTermsViewController: TermsDataViewDelegate {
    
    func termsDataView(didSelect model: TermsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        render?.listPosts(
            params: ListPostsAPI.Params(
                fetchType: .terms([model.id]),
                title: model.name
            )
        )
    }
}
