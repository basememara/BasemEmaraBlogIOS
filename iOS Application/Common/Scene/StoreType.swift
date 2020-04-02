//
//  StoreType.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-03-28.
//

import Foundation
import ZamzamCore

public protocol StoreType {}

/// The store to handle state, reducer, and action requests.
public class Store<Reducer: ReducerType>: StoreType {
    private let keyValue: WritableKeyPath<AppState, Reducer.State>
    private let reducer: Reducer
    private let middleware: [MiddlewareType]
    
    public init(
        for keyValue: WritableKeyPath<AppState, Reducer.State>,
        using reducer: Reducer,
        middleware: [MiddlewareType] = []
    ) {
        self.keyValue = keyValue
        self.reducer = reducer
        self.middleware = middleware
    }
}

public extension Store {
    
    /// The current value of the state.
    private(set) var state: Reducer.State {
        get { AppState.queue.sync { AppState.root[keyPath: keyValue] } }
        set {
            AppState.queue.sync(flags: .barrier) { AppState.root[keyPath: keyValue] = newValue }
            NotificationCenter.default.post(name: .stateDidChange, userInfo: [.state: newValue])
        }
    }
    
    func action(_ action: Reducer.Action) {
        middleware.forEach { $0(action) }
        reducer(&state, action)
    }
}

public extension Store {
    
    /// Observation to state changes and executes the block.
    ///
    /// - Parameters:
    ///   - token: An opaque object to act as the observer and will manage its auto release.
    ///   - observer: The block to be executed when the state changes.
    func callAsFunction(in token: inout NotificationCenter.Token?, observer: @escaping (Reducer.State) -> Void) {
        NotificationCenter.default.addObserver(forName: .stateDidChange, queue: .main, in: &token) { notification in
            guard let state = notification.userInfo?[.state] as? Reducer.State else { return }
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
