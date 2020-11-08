//
//  MainModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-15.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import ZamzamCore
import ZamzamUI

class MainModel: ObservableObject, Model {
    @Published var tabMenu: [MainAPI.TabItem]?
}
