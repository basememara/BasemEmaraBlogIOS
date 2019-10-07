//
//  Preferences.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-08-22.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import ZamzamCore

public extension PreferencesType {
    
    /// Returns the posts notified to the user.
    var notificationPostIDs: [Int] {
        get { get(.notificationPostIDs) ?? [] }
        set { set(newValue, forKey: .notificationPostIDs) }
    }
}

extension String.Keys {
    static let notificationPostIDs = String.Key<[Int]?>("notificationPostIDs")
}
