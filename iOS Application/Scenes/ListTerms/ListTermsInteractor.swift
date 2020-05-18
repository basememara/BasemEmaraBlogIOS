//
//  ListTermsAction.swift
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
            guard case .success(let item) = $0 else {
                self.presenter.displayTerms(
                    error: $0.error ?? .unknownReason(nil)
                )
                
                return
            }
            
            let terms = item.sorted { $0.count > $1.count }
            
            self.presenter.displayTerms(
                for: ListTermsAPI.TermsResponse(
                    terms: terms
                )
            )
        }
    }
}
