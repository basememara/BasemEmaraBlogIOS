//
//  SearchPostsModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import SwiftyPress
import ZamzamCore
import ZamzamUI

class SearchPostsModel: ObservableObject, Model {
    @Published private(set) var posts: [PostsDataViewModel]?
    @Published private(set) var error: ViewError?
}
