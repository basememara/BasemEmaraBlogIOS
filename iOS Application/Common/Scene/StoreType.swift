//
//  StoreType.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-03-28.
//

import Foundation
import ZamzamCore

public protocol StoreType: AnyObject {}

/// The store to handle state, reducer, and action requests.
public class Store<State: StateType>: StoreType {
    private let keyPath: WritableKeyPath<AppState, State>
    private let middleware: [MiddlewareType]
    
    public init(
        keyPath: WritableKeyPath<AppState, State>,
        with middleware: [MiddlewareType] = []
    ) {
        self.keyPath = keyPath
        self.middleware = middleware
    }
}

public extension Store {
    
    /// The current value of the state.
    private(set) var state: State {
        get { AppState.queue.sync { AppState.root[keyPath: keyPath] } }
        set {
            AppState.queue.sync(flags: .barrier) { AppState.root[keyPath: keyPath] = newValue }
            NotificationCenter.default.post(name: .stateDidChange, userInfo: [.state: newValue])
        }
    }
    
    /// Mutate the state by sending and action.
    /// - Parameter input: The input of the request.
    func send(_ input: State.Input) {
        middleware.forEach { $0(input) }
        state.receive(input)
    }
}

public extension Store {
    
    /// Observation to state changes and executes the block.
    ///
    /// - Parameters:
    ///   - token: An opaque object to act as the observer and will manage its auto release.
    ///   - observer: The block to be executed when the state changes.
    func callAsFunction(in token: inout NotificationCenter.Token?, observer: @escaping (State) -> Void) {
        NotificationCenter.default.addObserver(forName: .stateDidChange, queue: .main, in: &token) { notification in
            guard let state = notification.userInfo?[.state] as? State else { return }
            observer(state)
        }
    }
}

// MARK: - Helpers

extension AppState {
    fileprivate(set) static var root = AppState()
    fileprivate static let queue = DispatchQueue(label: "com.basememara.AppState", attributes: .concurrent)
}

private extension NSNotification.Name {
    static let stateDidChange = Notification.Name("stateDidChange")
}

private extension AnyHashable {
    static let state = "state"
}
