//
//  ShowSettingsViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ShowSettingsViewController: UITableViewController, HasDependencies {
    
    // MARK: - Controls
    
    @IBOutlet private weak var themeSwitch: UISwitch!
    
    // MARK: - Internal variable
    
    private lazy var preferences: PreferencesType = dependencies.resolve()
    
    // MARK: - Controller cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard #available(iOS 12.0, *) else { return }
        themeSwitch.isOn = view.traitCollection.userInterfaceStyle == .dark
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
