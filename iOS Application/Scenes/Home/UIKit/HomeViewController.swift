//
//  HomeViewController.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamCore
import ZamzamUI

final class HomeViewController: UIViewController {
    private let state: HomeState
    private let interactor: HomeInteractable?
    private var render: HomeRenderable?
    
    // MARK: - Controls
    
    private lazy var tableView = UITableView(
        frame: .zero,
        style: .grouped
    ).apply {
        $0.delegate = self
        $0.dataSource = self
        $0.tableHeaderView = headerView
    }
    
    private lazy var headerView = HomeHeaderView(
        state: state,
        delegate: self
    )
    
    // MARK: - Initializers
    
    init(
        state: HomeState,
        interactor: HomeInteractable?,
        render: ((UIViewController) -> HomeRenderable)?
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
        navigationController?.setNavigationBarHidden(true, animated: true)
        state.subscribe(load)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        state.unsubscribe()
    }
}

// MARK: - Setup

private extension HomeViewController {
    
    func prepare() {
        // Configure controls
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
    }
    
    func fetch() {
        interactor?.fetchProfile()
        interactor?.fetchMenu()
        interactor?.fetchSocial()
    }
    
    func load(_ result: StateChange<HomeState>) {
        if result == .updated(\HomeState.profile) || result == .initial {
            headerView.reloadProfile()
        }
        
        if result == .updated(\HomeState.socialMenu) || result == .initial {
            headerView.reloadSocialMenu()
        }
        
        if result == .updated(\HomeState.homeMenu) || result == .initial {
            tableView.reloadData()
        }
        
        if case .failure(let error) = result {
            present(alert: error.title, message: error.message)
        }
    }
}

// MARK: - Delegates

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = state
            .homeMenu[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return
        }
        
        render?.select(menu: item)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        state.homeMenu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.homeMenu[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        state.homeMenu[safe: section]?.title ??+ nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = state
            .homeMenu[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return UITableViewCell()
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: nil).apply {
            $0.textLabel?.text = item.title
            $0.imageView?.image = UIImage(named: item.icon)
        }
    }
}

extension HomeViewController: HomeHeaderViewDelegate {
    
    func didTapSocialButton(_ sender: UIButton) {
        guard let item = Social.allCases[safe: sender.tag] else { return }
        render?.select(social: item)
    }
}

// MARK: - Preview

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct HomeViewController_Preview: PreviewProvider {

    static var previews: some View {
        HomeViewController(
            state: AppPreview.homeState,
            interactor: nil,
            render: nil
        ).previews
    }
}
#endif
