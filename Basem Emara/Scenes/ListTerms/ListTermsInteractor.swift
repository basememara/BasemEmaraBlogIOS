//
//  ListTermsInteractor.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListTermsInteractor: ListTermsBusinessLogic {
    private let presenter: ListTermsPresentable
    private let taxonomyWorker: TaxonomyWorkerType
    
    init(presenter: ListTermsPresentable,
         taxonomyWorker: TaxonomyWorkerType) {
        self.presenter = presenter
        self.taxonomyWorker = taxonomyWorker
    }
}

extension ListTermsInteractor {
    
    func fetchTerms(with request: ListTermsModels.FetchTermsRequest) {
        taxonomyWorker.fetch {
            guard let terms = $0.value?.sorted(by: { $0.count > $1.count }), $0.isSuccess else {
                return self.presenter.presentTerms(
                    error: $0.error ?? DataError.unknownReason(nil)
                )
            }
            
            self.presenter.presentTerms(
                for: ListTermsModels.TermsResponse(
                    terms: terms
                )
            )
        }
    }
}

