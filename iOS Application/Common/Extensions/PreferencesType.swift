//
//  Preferences.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-08-22.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public extension PreferencesType {
    
    /// For reading themes from iOS dark/light mode
    var autoThemeEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "autoThemeEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "autoThemeEnabled") }
    }
}

public extension PreferencesType {
    
    /// Returns the posts notified to the user.
    var notificationPostIDs: [Int] {
        self.get(.notificationPostIDs) ?? []
    }
    
    func set(notificationPostIDs ids: [Int]) {
        set(ids, forKey: .notificationPostIDs)
    }
}

extension String.Keys {
    static let notificationPostIDs = String.Key<[Int]?>("notificationPostIDs")
}
