//
//  ShowBlogModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-14.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ShowBlogModel: ObservableObject, Model {
    @Published private(set) var latestPosts: [PostsDataViewModel]?
    @Published private(set) var popularPosts: [PostsDataViewModel]?
    @Published private(set) var topPickPosts: [PostsDataViewModel]?
    @Published private(set) var terms: [TermsDataViewModel]?
    @Published private(set) var error: ViewError?
}
