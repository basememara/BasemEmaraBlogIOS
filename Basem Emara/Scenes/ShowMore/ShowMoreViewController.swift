//
//  MoreViewController.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-05-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress

class ShowMoreViewController: UIViewController {
    
    @IBAction func themeSwitchChanged(_ sender: UISwitch) {
        let theme: Theme = sender.isOn ? DarkTheme() : LightTheme()
        theme.apply(for: UIApplication.shared)
    }
}
