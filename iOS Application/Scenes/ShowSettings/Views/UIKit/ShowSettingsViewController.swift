//
//  ShowSettingsViewController.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-11-11.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ShowSettingsViewController: UIViewController {
    private let store: Store<ShowSettingsState>
    private let interactor: ShowSettingsInteractorType?
    private let render: ShowSettingsRenderType?
    private var token: NotificationCenter.Token?
    
    // MARK: - Controls
    
    private lazy var tableView = makeTableView(delegate: self)
    private lazy var autoThemeSwitch = makeAutoThemeSwitch()
    
    // MARK: - Initializers
    
    init(
        store: Store<ShowSettingsState>,
        interactor: ShowSettingsInteractorType?,
        render: ShowSettingsRender?
    ) {
        self.store = store
        self.interactor = interactor
        self.render = render
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

private extension ShowSettingsViewController {
    
    func prepare() {
        // Configure controls
        navigationItem.title = .localized(.settingsTitle)
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
        
        // Bind state
        store(in: &token, observer: load)
    }
    
    func fetch() {
        interactor?.fetchMenu()
        interactor?.fetchTheme()
    }
    
    func load(_ state: ShowSettingsState) {
        tableView.reloadData()
        load(autoThemeEnabled: state.autoThemeEnabled)
        
        // TODO: Handle error
    }
    
    func load(autoThemeEnabled: Bool) {
        autoThemeSwitch.isOn = autoThemeEnabled
        
        guard #available(iOS 13, *) else { return }
        UIWindow.current?.overrideUserInterfaceStyle = autoThemeEnabled
            ? .unspecified : .dark
    }
}

// MARK: - Interactions

private extension ShowSettingsViewController {
    
    @objc func autoThemeSwitchChanged() {
        let request = ShowSettingsAPI.SetThemeRequest(
            autoThemeEnabled: autoThemeSwitch.isOn
        )
        
        interactor?.setTheme(with: request)
    }
}

// MARK: - Delegates

extension ShowSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = store.state
            .settingsMenu[safe: indexPath.row] else {
                return
        }
        
        switch item.type {
        case .notifications:
            (UIApplication.shared.delegate as? AppDelegate)?.pluginInstances
                .compactMap { $0 as? NotificationPlugin }
                .first?
                .register { [weak self] granted in
                    // TODO: Move to tutorial and localize
                    guard granted else {
                        self?.present(alert: "Please enable any time from iOS settings.")
                        return
                    }
                    
                    self?.present(alert: "You have registered to receive notifications.")
            }
        case .ios:
            render?.openSettings()
        case .theme:
            break
        }
    }
}

extension ShowSettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.state.settingsMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = store.state.settingsMenu[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        switch item.type {
        case .theme:
            return makeAutoThemeTableViewCell(text: item.title, icon: item.icon)
        default:
            return makeDefaultTableViewCell(text: item.title, icon: item.icon)
        }
    }
}

// MARK: - Helpers

private extension ShowSettingsViewController {
    
    func makeTableView(delegate: UITableViewDelegate & UITableViewDataSource) -> UITableView {
        UITableView().with {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
        }
    }
    
    func makeAutoThemeSwitch() -> UISwitch {
        UISwitch().with {
            $0.addTarget(self, action: #selector(autoThemeSwitchChanged), for: .valueChanged)
        }
    }
    
    func makeAutoThemeTableViewCell(text: String, icon: String) -> UITableViewCell {
        let cell = makeDefaultTableViewCell(text: text, icon: icon).with {
            $0.selectionStyle = .none
            $0.addSubview(autoThemeSwitch)
        }
        
        autoThemeSwitch.translatesAutoresizingMaskIntoConstraints = false
        autoThemeSwitch.trailingAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        autoThemeSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        load(autoThemeEnabled: store.state.autoThemeEnabled)
        
        return cell
    }
    
    func makeDefaultTableViewCell(text: String, icon: String) -> UITableViewCell {
        UITableViewCell(style: .default, reuseIdentifier: nil).with {
            $0.textLabel?.text = text
            $0.imageView?.image = UIImage(named: icon)
        }
    }
}
