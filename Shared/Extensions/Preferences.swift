//
//  Preferences.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-08-22.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation
import ZamzamCore

extension Preferences {
    
    /// For reading themes from iOS dark/light mode
    var autoThemeEnabled: Bool {
        self.get(.autoThemeEnabled) ?? false
    }
    
    func set(autoThemeEnabled value: Bool) {
        set(value, forKey: .autoThemeEnabled)
    }
}

extension Preferences {
    
    /// Returns the posts notified to the user.
    var notificationPostIDs: [Int] {
        self.get(.notificationPostIDs) ?? []
    }
    
    func set(notificationPostIDs ids: [Int]) {
        set(ids, forKey: .notificationPostIDs)
    }
}

private extension PreferencesAPI.Keys {
    static let autoThemeEnabled = PreferencesAPI.Key<Bool?>("autoThemeEnabled")
    static let notificationPostIDs = PreferencesAPI.Key<[Int]?>("notificationPostIDs")
}
