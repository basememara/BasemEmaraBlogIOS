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
    @Published var latestPosts: [PostsDataViewModel]?
    @Published var popularPosts: [PostsDataViewModel]?
    @Published var topPickPosts: [PostsDataViewModel]?
    @Published var terms: [TermsDataViewModel]?
    @Published var error: ViewError?
}
