//
//  ListTermsModel+Preview.swift
//  iOS
//
//  Created by Basem Emara on 2020-11-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

extension ListTermsModel {
    
    static let preview = ListTermsModel().apply {
        $0.terms = AppPreviews.shared.store.allTerms?.values.shuffled().prefix(25).array
    }
}
