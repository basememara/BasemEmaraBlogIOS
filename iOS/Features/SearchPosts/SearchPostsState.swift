//
//  SearchPostsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import SwiftyPress
import ZamzamCore
import ZamzamUI

class SearchPostsState: ObservableObject, Apply {
    @Published var posts: [PostsDataViewModel]?
    @Published var error: ViewError?
}
