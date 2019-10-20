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
    private let taxonomyWorker: TaxonomyWorkerType
    
    init(presenter: ListTermsPresentable, taxonomyWorker: TaxonomyWorkerType) {
        self.presenter = presenter
        self.taxonomyWorker = taxonomyWorker
    }
}

extension ListTermsAction {
    
    func fetchTerms(with request: ListTermsAPI.FetchTermsRequest) {
        taxonomyWorker.fetch(by: [.category, .tag]) {
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
