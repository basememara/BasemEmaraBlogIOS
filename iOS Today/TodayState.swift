//
//  TodayState.swift
//  BasemEmara iOS Today
//
//  Created by Basem Emara on 2020-05-23.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import Foundation.NSNotification
import SwiftyPress
import ZamzamUI

class TodayState: ObservableObject {
    @Published var posts: [PostsDataViewModel]?
    @Published var error: ViewError?
}
