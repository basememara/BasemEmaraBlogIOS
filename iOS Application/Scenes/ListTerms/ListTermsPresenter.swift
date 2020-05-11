//
//  ListTermsPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamUI

struct ListTermsPresenter<Store: StoreType>: ListTermsPresenterType where Store.State == ListTermsState {
    private let store: Store
    
    init(store: Store) {
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
        
        store.send(.loadTerms(viewModels))
    }
    
    func displayTerms(error: SwiftyPressError) {
        let viewModel = AppAPI.Error(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        store.send(.loadError(viewModel))
    }
}
