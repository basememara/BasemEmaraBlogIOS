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
    private let store: Store<ShowMoreState>
    private let interactor: ShowMoreInteractorType?
    private var token: NotificationCenter.Token?
    
    var render: ShowMoreRenderType?
    
    // MARK: - Controls
    
    private lazy var tableView = makeTableView(delegate: self)
    private lazy var socialCellStackView = makeSocialCellStackView()
    
    // MARK: - Initializers
    
    init(store: Store<ShowMoreState>, interactor: ShowMoreInteractorType?) {
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

private extension ShowMoreViewController {
    
    func prepare() {
        // Configure controls
        navigationItem.title = .localized(.moreTitle)
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
        
        // Bind state
        store(in: &token, observer: load)
    }
    
    func fetch() {
        interactor?.fetchMenu()
        interactor?.fetchSocial()
    }
    
    func load(_ state: ShowMoreState) {
        tableView.reloadData()
        load(state.socialMenu)
        
        // TODO: Handle error
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
            let item = store.state.moreMenu[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return
        }
        
        render?.select(menu: item, from: cell)
    }
}

extension ShowMoreViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        store.state.moreMenu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.state.moreMenu[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        store.state.moreMenu[safe: section]?.title ??+ nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = store.state
            .moreMenu[safe: indexPath.section]?.items[safe: indexPath.row] else {
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
        ).with {
            $0.delegate = delegate
            $0.dataSource = delegate
        }
    }
    
    func makeSocialCellStackView() -> UIStackView {
        UIStackView().with {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 12
        }
    }
    
    func makeSocialTableViewCell() -> UITableViewCell {
        UITableViewCell(frame: .zero).with {
            socialCellStackView.removeFromSuperview()
            $0.addSubview(socialCellStackView)
            $0.selectionStyle = .none
            
            load(store.state.socialMenu)
            
            socialCellStackView.translatesAutoresizingMaskIntoConstraints = false
            socialCellStackView.topAnchor.constraint(equalTo: $0.topAnchor, constant: 12).isActive = true
            socialCellStackView.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -12).isActive = true
            socialCellStackView.leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: 12).isActive = true
            socialCellStackView.trailingAnchor.constraint(lessThanOrEqualTo: $0.trailingAnchor).isActive = true
        }
    }
    
    func makeDefaultTableViewCell(text: String, icon: String) -> UITableViewCell {
        UITableViewCell(style: .default, reuseIdentifier: nil).with {
            $0.textLabel?.text = text
            $0.imageView?.image = UIImage(named: icon)
        }
    }
}
