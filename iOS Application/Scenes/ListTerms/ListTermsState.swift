//
//  ListTermsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import SwiftyPress

class ListTermsState: StateRepresentable {
    
    private(set) var terms: [TermsDataViewModel] = [] {
        willSet {
            guard newValue != terms, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != terms else { return }
            notificationPost(keyPath: \ListTermsState.terms)
        }
    }
    
    private(set) var error: AppAPI.Error? {
        willSet {
            guard newValue != error, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != error else { return }
            notificationPost(keyPath: \ListTermsState.error)
        }
    }
}

// MARK: - Action

enum ListTermsAction: Action {
    case loadTerms([TermsDataViewModel])
    case loadError(AppAPI.Error?)
}

// MARK: - Reducer

extension ListTermsState {
    
    func reduce(_ action: ListTermsAction) {
        switch action {
        case .loadTerms(let items):
            terms = items
        case .loadError(let item):
            error = item
        }
    }
}

// MARK: - Conformances

extension ListTermsState: Equatable {
    
    static func == (lhs: ListTermsState, rhs: ListTermsState) -> Bool {
        lhs.terms == rhs.terms
            && lhs.error == rhs.error
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ListTermsState: ObservableObject {}
#endif
