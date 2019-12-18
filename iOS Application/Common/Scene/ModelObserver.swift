//
//  StateObserver.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-17.
//

import Foundation

protocol ModelObserver: class {
    associatedtype Model = ModelType
    func newState(model: Model)
}

extension ModelType {
    
    /// Registers state changes and fires `newState(model:)` on broadcasts.
    ///
    /// - Parameters:
    ///   - model: The observer listening for model changes.
    ///   - token: An opaque object to act as the observer and will manage its auto release.
    ///   - notificationCenter: A notification dispatch mechanism that enables the broadcast of information to registered observers.
    func subscribe<T: ModelObserver>(_ observer: T, in token: inout NotificationCenter.Token?, using notificationCenter: NotificationCenter = .default) {
        // Execute on new subscription then await next broadcast
        if let model = self as? T.Model {
            observer.newState(model: model)
        }
        
        notificationCenter.addObserver(for: .AppStateDidUpdate, in: &token) { [weak observer] notification in
            guard let state = notification.userInfo?["substate"] as? T.Model else { return }
            observer?.newState(model: state)
        }
    }
}
