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

final class ShowSettingsViewController: UIViewController {
    private let state: ShowSettingsState
    private let interactor: ShowSettingsInteractable?
    private let render: ShowSettingsRenderable?
    
    // MARK: - Controls
    
    private lazy var tableView = makeTableView(delegate: self)
    private lazy var autoThemeSwitch = makeAutoThemeSwitch()
    
    // MARK: - Initializers
    
    init(
        state: ShowSettingsState,
        interactor: ShowSettingsInteractable?,
        render: ShowSettingsRenderable?
    ) {
        self.state = state
        self.interactor = interactor
        self.render = render
        
        super.init(nibName: nil, bundle: nil)
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

private extension ShowSettingsViewController {
    
    func prepare() {
        // Configure controls
        navigationItem.title = .localized(.settings)
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
        
        // Bind reactive data
        state.subscribe(load)
    }
    
    func fetch() {
        interactor?.fetchMenu()
        interactor?.fetchTheme()
    }
    
    func load(_ result: StateChange<ShowSettingsState>) {
        if result == .updated(\ShowSettingsState.settingsMenu) || result == .initial {
            tableView.reloadData()
        }
        
        if result == .updated(\ShowSettingsState.autoThemeEnabled) || result == .initial {
            load(autoThemeEnabled: state.autoThemeEnabled)
        }
        
        if case .failure(let error) = result {
            present(alert: error.title, message: error.message)
        }
    }
    
    func load(autoThemeEnabled: Bool) {
        autoThemeSwitch.isOn = autoThemeEnabled
        
        guard #available(iOS 13, *) else { return }
        view.window?.overrideUserInterfaceStyle =
            autoThemeEnabled ? .unspecified : .dark
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
        
        guard let item = state.settingsMenu[safe: indexPath.row] else {
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
        state.settingsMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = state.settingsMenu[safe: indexPath.row] else {
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
        UITableView().apply {
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
        }
    }
    
    func makeAutoThemeSwitch() -> UISwitch {
        UISwitch().apply {
            $0.addTarget(self, action: #selector(autoThemeSwitchChanged), for: .valueChanged)
        }
    }
    
    func makeAutoThemeTableViewCell(text: String, icon: String) -> UITableViewCell {
        let cell = makeDefaultTableViewCell(text: text, icon: icon).apply {
            $0.selectionStyle = .none
            $0.addSubview(autoThemeSwitch)
        }
        
        autoThemeSwitch.translatesAutoresizingMaskIntoConstraints = false
        autoThemeSwitch.trailingAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        autoThemeSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        load(autoThemeEnabled: state.autoThemeEnabled)
        
        return cell
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
struct ShowSettingsViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        UINavigationController(
            rootViewController: ShowSettingsViewController(
                state: AppPreview.showSettings,
                interactor: nil,
                render: nil
            )
        )
        .apply { $0.navigationBar.prefersLargeTitles = true }
        .previews
    }
}
#endif
