//
//  ReducerType.swift
//
//  Created by Basem Emara on 2019-11-22.
//

/// The reducer to dispatch an action to state for the scene.
public protocol ReducerType {
    associatedtype Action: ActionType
    associatedtype State: StateType
    
    /// Performs the logic and mutates the state.
    /// - Parameters:
    ///   - state: The state for the component.
    ///   - action: The action to perform on the state.
    func callAsFunction(_ state: inout State, _ action: Action)
}
