//
//  ListTermsPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamUI

struct ListTermsPresenter: ListTermsPresentable {
    private let store: StoreReducer<ListTermsReducer>
    
    init(_ store: @escaping StoreReducer<ListTermsReducer>) {
        self.store = store
    }
}

extension ListTermsPresenter {
    
    func displayTerms(for response: ListTermsAPI.TermsResponse) {
        let viewModels = response.terms.map {
            TermsDataViewModel(
                id: $0.id,
                name: $0.name,
                count: .localizedStringWithFormat("%d", $0.count),
                taxonomy: $0.taxonomy
            )
        }
        
        store(.loadTerms(viewModels))
    }
    
    func displayTerms(error: SwiftyPressError) {
        let viewModel = ViewError(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        store(.loadError(viewModel))
    }
}
