//
//  Preferences.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-08-22.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

public extension Preferences {
    
    /// For reading themes from iOS dark/light mode
    var autoThemeEnabled: Bool {
        UserDefaults.standard.bool(forKey: "autoThemeEnabled")
    }
    
    func set(autoThemeEnabled value: Bool) {
        UserDefaults.standard.set(value, forKey: "autoThemeEnabled")
    }
}

public extension Preferences {
    
    /// Returns the posts notified to the user.
    var notificationPostIDs: [Int] {
        self.get(.notificationPostIDs) ?? []
    }
    
    func set(notificationPostIDs ids: [Int]) {
        set(ids, forKey: .notificationPostIDs)
    }
}

extension PreferencesAPI.Keys {
    static let notificationPostIDs = PreferencesAPI.Key<[Int]?>("notificationPostIDs")
}
