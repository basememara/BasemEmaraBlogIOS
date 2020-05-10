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

class ListTermsViewController: UIViewController {
    private let store: Store<ListTermsState>
    private let interactor: ListTermsInteractorType?
    private var cancellable: NotificationCenter.Cancellable?
    
    var render: ListTermsRenderType?
    
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
        store: Store<ListTermsState>,
        interactor: ListTermsInteractorType?
    ) {
        self.store = store
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        fetch()
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
        
        // Bind state
        store(in: &cancellable, observer: load)
    }
    
    func fetch() {
        interactor?.fetchTerms(
            with: ListTermsAPI.FetchTermsRequest()
        )
    }
    
    func load(_ state: ListTermsState) {
        tableViewAdapter.reloadData(with: state.terms)
        
        // TODO: Handle error
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
