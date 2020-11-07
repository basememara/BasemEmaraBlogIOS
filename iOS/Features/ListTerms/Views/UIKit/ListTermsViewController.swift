//
//  ListTermsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Combine
import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

final class ListTermsViewController: UIViewController {
    private let state: ListTermsState
    private let interactor: ListTermsInteractable?
    private var render: ListTermsRenderable?
    private var cancellable = Set<AnyCancellable>()
    
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
        observe()
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingRemoved else { return }
        cancellable.removeAll()
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
    
    func observe() {
        state.$terms
            .compactMap { $0 }
            .sink(receiveValue: tableViewAdapter.reloadData)
            .store(in: &cancellable)
        
        state.$error
            .sink(receiveValue: load)
            .store(in: &cancellable)
    }
    
    func fetch() {
        interactor?.fetchTerms(
            with: ListTermsAPI.FetchTermsRequest()
        )
    }
}

private extension ListTermsViewController {
    
    func load(error: ViewError?) {
        guard let error = error else { return }
        present(alert: error.title, message: error.message)
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
struct ListTermsControllerPreview: PreviewProvider {
    
    static var previews: some View {
        UINavigationController(
            rootViewController: ListTermsViewController(
                state: Preview.listTermsState,
                interactor: nil,
                render: nil
            )
        )
        .apply { $0.navigationBar.prefersLargeTitles = true }
        .previews
    }
}
#endif
