//
//  StoreType.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-03-28.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSNotification
import ZamzamCore

public protocol StoreRepresentable: AnyObject {
    associatedtype StateType: State
    func send(_ action: StateType.ActionType)
}

/// The store to handle state, reducer, and action requests.
public class Store<StateType: State>: StoreRepresentable {
    private let keyPath: WritableKeyPath<AppState, StateType>
    private var testState: AppState?
    private let middleware: [Middleware]
    private let notificationCenter: NotificationCenter = .default
    
    public init(
        keyPath: WritableKeyPath<AppState, StateType>,
        with middleware: [Middleware] = []
    ) {
        self.keyPath = keyPath
        self.middleware = middleware
    }
}

public extension Store {
    
    /// The current value of the state.
    private(set) var state: StateType {
        get { (testState ?? AppState.root)[keyPath: keyPath] }
        set {
            #if canImport(Combine)
            if #available(iOS 13, *) {
                objectWillChange.send()
            }
            #endif
            
            AppState.root[keyPath: keyPath] = newValue
            notificationCenter.post(name: .stateDidChange, userInfo: [.state: newValue])
        }
    }
    
    /// Mutate the state by sending an action.
    ///
    /// - Parameter action: The action of the request.
    func send(_ action: StateType.ActionType) {
        middleware.forEach { $0(action) }
        state.receive(action)
    }
}

public extension Store {
    
    /// Observation to state changes and executes the block.
    ///
    /// - Parameters:
    ///   - cancellable: An opaque object to act as the observer and will manage its auto release.
    ///   - observer: The block to be executed when the state changes.
    func callAsFunction(in cancellable: inout NotificationCenter.Cancellable?, observer: @escaping (StateType) -> Void) {
        notificationCenter.addObserver(forName: .stateDidChange, queue: .main, in: &cancellable) { notification in
            guard let state = notification.userInfo?[.state] as? StateType else { return }
            observer(state)
        }
    }
}

#if canImport(Combine)
import Combine

@available(iOS 13, *)
extension Store: ObservableObject {}
#endif

// MARK: - Helpers

extension AppState {
    fileprivate(set) static var root = AppState()
}

private extension NSNotification.Name {
    static let stateDidChange = Notification.Name("stateDidChange")
}

private extension AnyHashable {
    static let state = "state"
}

// MARK: - Testing

#if DEBUG
extension Store {
    
    /// Initializer used for constructing custom previews for testing.
    convenience init(
        keyPath: WritableKeyPath<AppState, StateType>,
        for testState: AppState
    ) {
        self.init(keyPath: keyPath)
        self.testState = testState
    }
}
#endif
