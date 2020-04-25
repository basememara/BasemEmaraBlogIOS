//
//  ListTermsAction.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListTermsInteractor: ListTermsInteractorType {
    private let presenter: ListTermsPresenterType
    private let taxonomyRepository: TaxonomyRepositoryType
    
    init(presenter: ListTermsPresenterType, taxonomyRepository: TaxonomyRepositoryType) {
        self.presenter = presenter
        self.taxonomyRepository = taxonomyRepository
    }
}

extension ListTermsInteractor {
    
    func fetchTerms(with request: ListTermsAPI.FetchTermsRequest) {
        taxonomyRepository.fetch(by: [.category, .tag]) {
            guard case .success(let value) = $0 else {
                return self.presenter.displayTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
            }
            
            let terms = value.sorted { $0.count > $1.count }
            
            self.presenter.displayTerms(
                for: ListTermsAPI.TermsResponse(
                    terms: terms
                )
            )
        }
    }
}
