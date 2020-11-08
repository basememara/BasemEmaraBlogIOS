//
//  ShowPostModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-27.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ShowPostModel: ObservableObject, Model {
    @Published var web: ShowPostAPI.WebViewModel?
    @Published var post: ShowPostAPI.PostViewModel?
    @Published var isFavorite = false
    @Published var error: ViewError?
}
