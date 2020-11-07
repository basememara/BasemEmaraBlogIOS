//
//  ListTermsInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListTermsInteractor: ListTermsInteractable {
    private let presenter: ListTermsPresentable
    private let taxonomyRepository: TaxonomyRepository
    
    init(presenter: ListTermsPresentable, taxonomyRepository: TaxonomyRepository) {
        self.presenter = presenter
        self.taxonomyRepository = taxonomyRepository
    }
}

extension ListTermsInteractor {
    
    func fetchTerms(with request: ListTermsAPI.FetchTermsRequest) {
        taxonomyRepository.fetch(by: [.category, .tag]) {
            guard case .success(let items) = $0 else {
                presenter.displayTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
                
                return
            }
            
            let terms = items.sorted { $0.count > $1.count }
            
            presenter.displayTerms(
                for: ListTermsAPI.TermsResponse(
                    terms: terms
                )
            )
        }
    }
}
