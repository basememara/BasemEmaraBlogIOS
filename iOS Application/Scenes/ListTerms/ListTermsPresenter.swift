//
//  ListTermsPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamUI

struct ListTermsPresenter: ListTermsPresenterType {
    private let send: SendAction<ListTermsState>
    
    init(send: @escaping SendAction<ListTermsState>) {
        self.send = send
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
        
        send(.loadTerms(viewModels))
    }
    
    func displayTerms(error: DataError) {
        let viewModel = AppAPI.Error(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        send(.loadError(viewModel))
    }
}
