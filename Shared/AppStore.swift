//
//  AppStore.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-14.
//

import Combine
import SwiftyPress

class AppStore: ObservableObject {
    @Published var allPosts: [Int: PostsDataViewModel]?
    @Published var allTerms: [Int: TermsDataViewModel]?
}
