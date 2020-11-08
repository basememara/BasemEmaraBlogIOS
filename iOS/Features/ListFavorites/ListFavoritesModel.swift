//
//  ListFavoritesModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-22.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ListFavoritesModel: ObservableObject, Model {
    @Published var favorites: [PostsDataViewModel]?
    @Published var error: ViewError?
}
