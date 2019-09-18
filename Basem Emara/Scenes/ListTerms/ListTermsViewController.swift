//
//  ListTermsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
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
    
    // MARK: - Scene variables
    
    private lazy var interactor: ListTermsBusinessLogic = ListTermsInteractor(
        presenter: ListTermsPresenter(viewController: self),
        taxonomyWorker: taxonomyWorker
    )
    
    private lazy var router: ListTermsRoutable = ListTermsRouter(
        viewController: self
    )
    
    // MARK: - Internal variable
    
    @Inject private var taxonomyWorker: TaxonomyWorkerType
    
    private lazy var tableViewAdapter = TermsDataViewAdapter(
        for: tableView,
        delegate: self
    )
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
}

// MARK: - Events

private extension ListTermsViewController {
    
    func loadData() {
        interactor.fetchTerms(
            with: ListTermsModels.FetchTermsRequest()
        )
    }
}

// MARK: - Scene cycle

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
