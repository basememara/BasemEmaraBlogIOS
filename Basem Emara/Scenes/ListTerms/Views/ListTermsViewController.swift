//
//  ListTermsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import Shank
import SwiftyPress
import ZamzamUI

class ListTermsViewController: UIViewController {
    
    // MARK: - Controls
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(nib: TermTableViewCell.self)
            tableView.contentInset.bottom += 20
        }
    }
    
    // MARK: - Dependencies
    
    @Inject private var module: ListTermsModuleType
    
    private lazy var action: ListTermsActionable = module.component(with: self)
    private lazy var router: ListTermsRoutable = module.component(with: self)
    
    // MARK: - State
    
    private lazy var tableViewAdapter = TermsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
}

// MARK: - Setup

private extension ListTermsViewController {
    
    func loadData() {
        action.fetchTerms(
            with: ListTermsAPI.FetchTermsRequest()
        )
    }
}

// MARK: - Scene

extension ListTermsViewController: ListTermsDisplayable {
    
    func displayTerms(with viewModels: [TermsDataViewModel]) {
        tableViewAdapter.reloadData(with: viewModels)
    }
}

// MARK: - Delegates

extension ListTermsViewController: TermsDataViewDelegate {
    
    func termsDataView(didSelect model: TermsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable) {
        router.listPosts(
            params: .init(
                fetchType: .terms([model.id]),
                title: model.name
            )
        )
    }
}
