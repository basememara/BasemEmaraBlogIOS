//
//  HomeViewController.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-05-20.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Combine
import SwiftyPress
import UIKit
import ZamzamCore
import ZamzamUI

final class HomeViewController: UIViewController {
    private let model: HomeModel
    private let interactor: HomeInteractable?
    private var render: HomeRenderable?
    private var cancellable = Set<AnyCancellable>()

    // MARK: - Controls
    
    private lazy var tableView = UITableView(
        frame: .zero,
        style: .grouped
    ).apply {
        $0.delegate = self
        $0.dataSource = self
        $0.tableHeaderView = headerView
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var headerView = HomeHeaderView(delegate: self)
    
    // MARK: - Initializers
    
    init(
        model: HomeModel,
        interactor: HomeInteractable?,
        render: ((UIViewController) -> HomeRenderable)?
    ) {
        self.model = model
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingRemoved else { return }
        cancellable.removeAll()
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
    
    func observe() {
        model.$homeMenu
            .compactMap { $0 }
            .sink(receiveValue: load)
            .store(in: &cancellable)
        
        model.$profile
            .compactMap { $0 }
            .sink(receiveValue: headerView.load)
            .store(in: &cancellable)
        
        model.$socialMenu
            .compactMap { $0 }
            .sink(receiveValue: headerView.load)
            .store(in: &cancellable)
    }
    
    func fetch() {
        interactor?.fetchProfile()
        interactor?.fetchMenu()
        interactor?.fetchSocial()
    }
}

private extension HomeViewController {
    
    func load(menuSections: [HomeAPI.MenuSection]) {
        tableView.reloadData()
    }
}

// MARK: - Delegates

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = model
            .homeMenu?[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return
        }
        
        render?.select(menu: item)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.homeMenu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.homeMenu?[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        model.homeMenu?[safe: section]?.title ??+ nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = model
            .homeMenu?[safe: indexPath.section]?.items[safe: indexPath.row] else {
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
struct HomeViewControllerPreview: PreviewProvider {

    static var previews: some View {
        HomeViewController(
            model: .preview,
            interactor: nil,
            render: nil
        ).previews
    }
}
#endif
