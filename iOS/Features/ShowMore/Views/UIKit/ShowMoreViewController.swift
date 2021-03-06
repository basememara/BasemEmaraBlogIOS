//
//  MoreViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Combine
import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

final class ShowMoreViewController: UIViewController {
    private let model: ShowMoreModel
    private let interactor: ShowMoreInteractable?
    private(set) var render: ShowMoreRenderable?
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Controls
    
    private lazy var tableView = makeTableView(delegate: self)
    private lazy var socialCellStackView = makeSocialCellStackView()
    private lazy var activityIndicatorView = view.makeActivityIndicator()
    
    // MARK: - Initializers
    
    init(
        model: ShowMoreModel,
        interactor: ShowMoreInteractable?,
        render: ((UIViewController & Refreshable) -> ShowMoreRenderable)?
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingRemoved else { return }
        cancellable.removeAll()
    }
}

// MARK: - Setup

private extension ShowMoreViewController {
    
    func prepare() {
        // Configure controls
        navigationItem.title = .localized(.more)
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
    }
    
    func observe() {
        model.$moreMenu
            .compactMap { $0 }
            .sink(receiveValue: load)
            .store(in: &cancellable)
        
        model.$socialMenu
            .compactMap { $0 }
            .sink(receiveValue: load)
            .store(in: &cancellable)
    }
    
    func fetch() {
        interactor?.fetchMenu()
        interactor?.fetchSocial()
    }
}

private extension ShowMoreViewController {
    
    func load(moreMenu: [ShowMoreAPI.MenuSection]) {
        tableView.reloadData()
    }
    
    func load(socialMenu: [ShowMoreAPI.SocialItem]) {
        socialCellStackView.setArrangedSubviews(
            socialMenu.map {
                SocialButton(
                    social: $0.type,
                    target: self,
                    action: #selector(didTapSocialButton)
                )
            }
        )
    }
}

// MARK: - Interactions

extension ShowMoreViewController {
    
    @objc func didTapSocialButton(_ sender: UIButton) {
        guard let item = Social.allCases[safe: sender.tag] else { return }
        render?.select(social: item)
    }
}

// MARK: - Delegates

extension ShowMoreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath),
            let item = model.moreMenu?[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return
        }
        
        render?.select(menu: item, from: cell)
    }
}

extension ShowMoreViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.moreMenu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.moreMenu?[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        model.moreMenu?[safe: section]?.title ??+ nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = model.moreMenu?[safe: indexPath.section]?
            .items[safe: indexPath.row] else {
                return UITableViewCell()
        }
        
        switch item.type {
        case .social:
            return makeSocialTableViewCell()
        default:
            return makeDefaultTableViewCell(text: item.title, icon: item.icon)
        }
    }
}

extension ShowMoreViewController: Refreshable {
    
    func beginRefreshing() {
        activityIndicatorView.startAnimating()
    }
    
    func endRefreshing() {
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - Helpers

private extension ShowMoreViewController {
    
    func makeTableView(delegate: UITableViewDelegate & UITableViewDataSource) -> UITableView {
        UITableView(
            frame: .zero,
            style: .grouped
        ).apply {
            $0.delegate = delegate
            $0.dataSource = delegate
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    func makeSocialCellStackView() -> UIStackView {
        UIStackView().apply {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 12
        }
    }
    
    func makeSocialTableViewCell() -> UITableViewCell {
        UITableViewCell(frame: .zero).apply {
            $0.addSubview(socialCellStackView)
            $0.selectionStyle = .none
            
            if let socialMenu = model.socialMenu {
                load(socialMenu: socialMenu)
            }
            
            socialCellStackView.translatesAutoresizingMaskIntoConstraints = false
            socialCellStackView.topAnchor.constraint(equalTo: $0.topAnchor, constant: 12).isActive = true
            socialCellStackView.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -12).isActive = true
            socialCellStackView.leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: 12).isActive = true
            socialCellStackView.trailingAnchor.constraint(lessThanOrEqualTo: $0.trailingAnchor).isActive = true
        }
    }
    
    func makeDefaultTableViewCell(text: String, icon: String) -> UITableViewCell {
        UITableViewCell(style: .default, reuseIdentifier: nil).apply {
            $0.textLabel?.text = text
            $0.imageView?.image = UIImage(named: icon)
        }
    }
}

// MARK: - Preview

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct ShowMoreViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        UINavigationController(
            rootViewController: ShowMoreViewController(
                model: .preview,
                interactor: nil,
                render: nil
            )
        )
        .apply { $0.navigationBar.prefersLargeTitles = true }
        .previews
    }
}
#endif
