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

class ShowSettingsViewController: UITableViewController {
    
    // MARK: - Controls
    
    @IBOutlet private weak var autoThemeSwitch: UISwitch!
    
    // MARK: - Dependencies
    
    @Inject private var module: SwiftyPressCore
    private lazy var preferences: PreferencesType = module.dependency()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Setup

private extension ShowSettingsViewController {
    
    func configure() {
        autoThemeSwitch.isOn = preferences.autoThemeEnabled
    }
}

// MARK: - Interactions

private extension ShowSettingsViewController {
    
    @IBAction func autoThemeSwitchChanged(_ sender: UISwitch) {
        preferences.autoThemeEnabled = sender.isOn
        
        guard #available(iOS 13.0, *) else { return }
        UIWindow.current?.overrideUserInterfaceStyle = sender.isOn ? .unspecified : .dark
    }
}

// MARK: - Nested types

extension ShowSettingsViewController: CellIdentifiable {
    
    enum CellIdentifier: String {
        case notifications
        case ios
    }
}

// MARK: - Delegates

extension ShowSettingsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath),
            let identifier = CellIdentifier(from: cell) else {
                return
        }
        
        switch identifier {
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
            guard let settings = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settings)
        }
    }
}
