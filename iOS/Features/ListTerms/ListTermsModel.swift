//
//  ListTermsModel.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import SwiftyPress
import ZamzamCore
import ZamzamUI

class ListTermsModel: ObservableObject, Model {
    @Published private(set) var terms: [TermsDataViewModel]?
    @Published private(set) var error: ViewError?
}
