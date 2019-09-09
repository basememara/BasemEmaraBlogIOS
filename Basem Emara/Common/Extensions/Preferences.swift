//
//  Preferences.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-08-22.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

public extension PreferencesType {
    
    /// Returns the current favorite posts.
    var notificationPostIDs: [Int] {
        get { return get(.notificationPostIDs) ?? [] }
        set { set(newValue, forKey: .notificationPostIDs) }
    }
}

extension String.Keys {
    static let notificationPostIDs = String.Key<[Int]?>("notificationPostIDs")
}
