//
//  StateRepresentable.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-11-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification

/// The data of the component.
public protocol StateRepresentable: AnyObject {
    associatedtype ActionType: Action
    func callAsFunction(_ action: ActionType)
}

// MARK: - Pre-SwiftUI Reactive

extension StateRepresentable {
    
    /// Observation to state changes and executes the block.
    ///
    /// This will not be needed once fully migrated to SwiftUI. `ObservableObject` is planned.
    ///
    /// - Parameters:
    ///   - cancellable: An opaque object to act as the observer and will manage its auto release.
    ///   - observer: The block to be executed when the state changes.
    func subscribe<State: StateRepresentable>(_ observer: @escaping (PartialKeyPath<State>?) -> Void, in cancellable: inout NotificationCenter.Cancellable?) {
        // Load initial state
        observer(nil)
        
        NotificationCenter.default.addObserver(forName: .stateDidChange, queue: .main, in: &cancellable) { notification in
            guard let keyPath = notification.userInfo?[.keyPath] as? PartialKeyPath<State> else { return }
            observer(keyPath)
        }
    }
    
    /// Publishes the change when the state has changed. Call this during `didSet` with the key path that triggered the change.
    ///
    /// This will not be needed once fully migrated to SwiftUI. `@Publish` is planned.
    func notificationPost<StateType: StateRepresentable>(keyPath: PartialKeyPath<StateType>) {
        NotificationCenter.default.post(name: .stateDidChange, userInfo: [.keyPath: keyPath])
    }
}

// MARK: - Post-SwiftUI Reactive

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension StateRepresentable where Self: ObservableObject, Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    
    /// Publishes the change when the state has changed. Call this during `willSet`.
    ///
    /// Use `@Publish` when fully migrated to SwiftUI then deprecate this method.
    func combineSend() {
        objectWillChange.send()
    }
}
#endif

// MARK: - Helpers

extension NSNotification.Name {
    static let stateDidChange = Notification.Name("stateDidChange")
}

extension AnyHashable {
    static let keyPath = "keyPath"
}
