//
//  MoreViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

final class ShowMoreViewController: UIViewController {
    private let state: ShowMoreState
    private let interactor: ShowMoreInteractable?
    private(set) var render: ShowMoreRenderable?
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Controls
    
    private lazy var tableView = makeTableView(delegate: self)
    private lazy var socialCellStackView = makeSocialCellStackView()
    
    // MARK: - Initializers
    
    init(
        state: ShowMoreState,
        interactor: ShowMoreInteractable?,
        render: ((UIViewController) -> ShowMoreRenderable)?
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
}

// MARK: - Setup

private extension ShowMoreViewController {
    
    func prepare() {
        // Configure controls
        navigationItem.title = .localized(.moreTitle)
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
        
        // Reactive data
        state.subscribe(load, in: &cancellable)
    }
    
    func fetch() {
        interactor?.fetchMenu()
        interactor?.fetchSocial()
    }
    
    func load(_ keyPath: PartialKeyPath<ShowMoreState>?) {
        if keyPath == \ShowMoreState.moreMenu || keyPath == nil {
            tableView.reloadData()
        }
        
        if keyPath == \ShowMoreState.socialMenu || keyPath == nil {
            load(state.socialMenu)
        }
    }
    
    func load(_ state: [ShowMoreAPI.SocialItem]) {
        socialCellStackView.setArrangedSubviews(
            state.map {
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
            let item = state.moreMenu[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return
        }
        
        render?.select(menu: item, from: cell)
    }
}

extension ShowMoreViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        state.moreMenu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.moreMenu[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        state.moreMenu[safe: section]?.title ??+ nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = state.moreMenu[safe: indexPath.section]?
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

// MARK: - Helpers

private extension ShowMoreViewController {
    
    func makeTableView(delegate: UITableViewDelegate & UITableViewDataSource) -> UITableView {
        UITableView(
            frame: .zero,
            style: .grouped
        ).apply {
            $0.delegate = delegate
            $0.dataSource = delegate
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
            
            load(state.socialMenu)
            
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
