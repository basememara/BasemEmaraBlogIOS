//
//  TermsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-05-31.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress
import ZamzamUI

class TermsState: StateRepresentable {
    
    fileprivate(set) var allTerms: [Int: TermsDataViewModel] = [:] {
        willSet {
            guard newValue != allTerms, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != allTerms else { return }
            notificationPost(for: \Self.allTerms)
        }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension TermsState: ObservableObject {}
#endif

// MARK: - Reducer

enum TermsReducer: Reducer {
    case mergeTerms([TermsDataViewModel])
}

extension AppStore {
    
    func reduce(_ reducer: TermsReducer) {
        switch reducer {
        case .mergeTerms(let items):
            termsState.allTerms.merge(items.map { ($0.id, $0) }) { $1 }
        }
    }
}
