//
//  ListTermsPresenter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

struct ListTermsPresenter: ListTermsPresentable {
    private weak var viewController: ListTermsDisplayable?
    
    init(viewController: ListTermsDisplayable?) {
        self.viewController = viewController
    }
}

extension ListTermsPresenter {
    
    func presentTerms(for response: ListTermsModels.TermsResponse) {
        let viewModels = response.terms.map {
            TermsDataViewModel(
                id: $0.id,
                name: $0.name,
                count: .localizedStringWithFormat("%d", $0.count),
                taxonomy: $0.taxonomy
            )
        }
        
        viewController?.displayTerms(with: viewModels)
    }
    
    func presentTerms(error: DataError) {
        let viewModel = AppModels.Error(
            title: .localized(.termsErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}
