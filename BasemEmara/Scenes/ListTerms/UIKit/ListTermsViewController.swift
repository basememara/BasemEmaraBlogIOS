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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingRemoved else { return }
        state.unsubscribe()
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
        
        // Bind reactive data
        state.subscribe(load)
    }
    
    func fetch() {
        interactor?.fetchTerms(
            with: ListTermsAPI.FetchTermsRequest()
        )
    }
    
    func load(_ result: StateChange<ListTermsState>) {
        switch result {
        case .updated(\ListTermsState.terms), .initial:
            tableViewAdapter.reloadData(with: state.terms)
        case .failure(let error):
            present(alert: error.title, message: error.message)
        default:
            break
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

// MARK: - Preview

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct ListTermsController_Preview: PreviewProvider {
    
    static var previews: some View {
        UINavigationController(
            rootViewController: ListTermsViewController(
                state: AppPreview.listTermsState,
                interactor: nil,
                render: nil
            )
        )
        .apply { $0.navigationBar.prefersLargeTitles = true }
        .previews
    }
}
#endif
