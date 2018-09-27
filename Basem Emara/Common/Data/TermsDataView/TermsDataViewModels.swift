//
//  TagsDataViewModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct TermsDataViewModel {
    let id: Int
    let name: String
    let count: String
    let taxonomy: Taxonomy
}

protocol TermsDataViewCell {
    func bind(_ model: TermsDataViewModel)
}

