//
//  StoreType.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-03-28.
//

import Foundation.NSNotification
import ZamzamCore

public protocol StoreType: AnyObject {
    associatedtype State: StateType
    var state: State { get }
}

/// The store to handle state, reducer, and action requests.
public class Store<State: StateType>: StoreType {
    private let keyPath: WritableKeyPath<AppState, State>
    private var testState: AppState?
    private let middleware: [MiddlewareType]
    private let notificationCenter: NotificationCenter = .default
    
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
        get { (testState ?? AppState.root)[keyPath: keyPath] }
        set {
            #if canImport(Combine)
            if #available(iOS 13.0, *) {
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
    func send(_ action: State.Action) {
        middleware.forEach { $0(action) }
        state.receive(action)
    }
}

public extension Store {
    
    /// Observation to state changes and executes the block.
    ///
    /// - Parameters:
    ///   - token: An opaque object to act as the observer and will manage its auto release.
    ///   - observer: The block to be executed when the state changes.
    func callAsFunction(in token: inout NotificationCenter.Token?, observer: @escaping (State) -> Void) {
        notificationCenter.addObserver(forName: .stateDidChange, queue: .main, in: &token) { notification in
            guard let state = notification.userInfo?[.state] as? State else { return }
            observer(state)
        }
    }
}

#if canImport(Combine)
import Combine

@available(iOS 13.0, *)
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
        keyPath: WritableKeyPath<AppState, State>,
        for testState: AppState
    ) {
        self.init(keyPath: keyPath)
        self.testState = testState
    }
}
#endif
