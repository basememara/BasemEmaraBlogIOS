//
//  ListTermsState.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import SwiftyPress
import ZamzamUI

class ListTermsState: StateRepresentable {
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    fileprivate(set) var terms: [TermsDataViewModel] = [] {
        willSet {
            guard newValue != terms, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != terms else { return }
            notificationPost(for: \Self.terms)
        }
    }
    
    fileprivate(set) var error: ViewError? {
        willSet {
            guard newValue != error, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != error else { return }
            notificationPost(for: \Self.error)
        }
    }
}

extension ListTermsState {
    
    func subscribe(_ observer: @escaping (StateChange<ListTermsState>) -> Void) {
        subscribe(observer, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ListTermsState: ObservableObject {}
#endif

// MARK: - Reducer

enum ListTermsReducer: Reducer {
    case loadTerms([TermsDataViewModel])
    case loadError(ViewError)
}

extension AppStore {
    
    func reduce(_ reducer: ListTermsReducer) {
        switch reducer {
        case .loadTerms(let items):
            listTermsState.terms = items
        case .loadError(let item):
            listTermsState.error = item
        }
    }
}
