//
//  ListTermsAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListTermsAction: ListTermsActionable {
    private let presenter: ListTermsPresentable
    private let taxonomyProvider: TaxonomyProviderType
    
    init(presenter: ListTermsPresentable, taxonomyProvider: TaxonomyProviderType) {
        self.presenter = presenter
        self.taxonomyProvider = taxonomyProvider
    }
}

extension ListTermsAction {
    
    func fetchTerms(with request: ListTermsAPI.FetchTermsRequest) {
        taxonomyProvider.fetch(by: [.category, .tag]) {
            guard case .success(let value) = $0 else {
                return self.presenter.presentTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            let terms = value.sorted { $0.count > $1.count }
            
            self.presenter.presentTerms(
                for: ListTermsAPI.TermsResponse(
                    terms: terms
                )
            )
        }
    }
}
