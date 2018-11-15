//
//  ShowSettingsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class ShowSettingsViewController: UITableViewController, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet weak var themeSwitch: UISwitch!
    
    // MARK: - Internal variable
    
    private lazy var preferences: PreferencesType = dependencies.resolve()
    
    // MARK: - Controller cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Events

private extension ShowSettingsViewController {
    
    func configure() {
        guard let currentTheme = preferences.get(.currentTheme) else { return }
        themeSwitch.isOn = ThemePreset(rawValue: currentTheme) == .dark
    }
}

// MARK: - Interactions

private extension ShowSettingsViewController {
    
    @IBAction func themeSwitchChanged(_ sender: UISwitch) {
        let preset: ThemePreset = sender.isOn ? .dark : .light
        preferences.set(preset.rawValue, forKey: .currentTheme)
        preset.type.apply(for: UIApplication.shared)
    }
}

// MARK: - Nested types

extension ShowSettingsViewController: CellIdentifiable {
    
    enum CellIdentifier: String {
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
        case .ios:
            guard let settings = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settings)
        }
    }
}
