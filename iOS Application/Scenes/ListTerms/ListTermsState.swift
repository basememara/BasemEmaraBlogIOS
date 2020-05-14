//
//  ListTermsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct ListTermsState: State {
    private(set) var terms: [TermsDataViewModel] = []
    private(set) var error: AppAPI.Error?
}

// MARK: - Reducer

extension ListTermsState {
    
    enum ListTermsAction: Action {
        case loadTerms([TermsDataViewModel])
        case loadError(AppAPI.Error?)
    }
    
    mutating func callAsFunction(_ action: ListTermsAction) {
        switch action {
        case .loadTerms(let value):
            terms = value
        case .loadError(let value):
            error = value
        }
    }
}
